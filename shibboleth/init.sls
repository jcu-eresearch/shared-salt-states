include:
  - jcu.ntp

{% set shibboleth_user = salt['pillar.get']('shibboleth:user', 'shibd') %}
{% set shibboleth_group = salt['pillar.get']('shibboleth:group', 'shibd') %}

{# Use a special case for RHEL 6; Salt returns a tuple. #}
# For base packages
Shibboleth package repository:
   pkgrepo.managed:
      - name: security_shibboleth
      - humanname: Shibboleth
      - gpgcheck: 1
      - enabled: 1
{% if grains['os_family'] == 'RedHat' %}
  {% if grains['osmajorrelease'] in ('5', '7') %}
      - baseurl: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_CentOS-{{ grains['osmajorrelease'] }}/
      - gpgkey: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_CentOS-{{ grains['osmajorrelease'] }}/repodata/repomd.xml.key
  {% elif grains['osmajorrelease'] == '6' %}
      - baseurl: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_CentOS-6/
      - gpgkey: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_CentOS-6/repodata/repomd.xml.key
  {% endif %}
{% elif grains['os_family'] == 'Debian' %}
      # Coming soon
{% endif %}

shibboleth:
   pkg.installed:
      - refresh: true
      - require:
         - pkgrepo: Shibboleth package repository
         - service: ntp
   service.running:
      - name: shibd
      - enable: True
      - require:
         - pkg: shibboleth

# For any configured providers, download the provider certificates
{% from "jcu/shibboleth/providers.yaml" import shibboleth_providers with context %}
{% for provider in salt['pillar.get']('shibboleth:providers', ['aaf']) %}
{% set cert_metadata = shibboleth_providers[provider]['certificate'] %}
shibboleth {{ provider }} certificate:
  file.managed:
    - name: {{ cert_metadata['name'] }}
    - source: {{ cert_metadata['source'] }}
    - source_hash: {{ cert_metadata['source_hash'] }}
    - user: root
    - group: root
    - mode: 644
    - require_in:
      - file: shibboleth configuration
    - require:
      - pkg: shibboleth
{% endfor %}

# Templated for multiple Shibboleth providers
shibboleth configuration:
  file.managed:
    - name: /etc/shibboleth/shibboleth2.xml
    - source: salt://jcu/shibboleth/shibboleth2.xml
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: shibboleth
      - file: shibboleth identity
      - file: /etc/shibboleth/attribute-map.xml
    - watch_in:
      - service: shibboleth

/etc/shibboleth/attribute-map.xml:
  file.managed:
    - source: salt://jcu/shibboleth/attribute-map.xml
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: shibboleth
    - watch_in:
      - service: shibboleth

/usr/share/shibboleth/logo.png:
  file.managed:
    - source: salt://jcu/shibboleth/shibboleth-logo.png
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: shibboleth

# Generate identity, or manage identity files (if provided)
{% if salt['pillar.get']('shibboleth:certificate', '') %}
shibboleth certificate:
  file.managed:
    - name: /etc/shibboleth/sp-cert.pem
    - contents_pillar: 'shibboleth:certificate'
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: shibboleth
    - require_in:
      - service: shibboleth

shibboleth identity:
  file.managed:
    - name: /etc/shibboleth/sp-key.pem
    - contents_pillar: 'shibboleth:key'
    - user: shibd
    - group: shibd
    - mode: 400
    - require:
      - file: shibboleth certificate
    - require_in:
      - service: shibboleth
{% else %}
shibboleth identity creation:
  cmd.run:
    - name: >
        /etc/shibboleth/keygen.sh -o /etc/shibboleth/
        -u '{{ shibboleth_user }}'
        -g '{{ shibboleth_group }}'
        -h '{{ pillar['shibboleth']['host'] }}'
        -e '{{ pillar['shibboleth']['entityID'] }}'
    - unless: test -r /etc/shibboleth/sp-cert.pem || test -r /etc/shibboleth/sp-key.pem
    - require:
      - pkg: shibboleth

shibboleth identity:
  file.exists:
    - name: /etc/shibboleth/sp-cert.pem
    - require:
      - cmd: shibboleth identity creation
{% endif %}

