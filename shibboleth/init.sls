{% set shibboleth_user = salt['pillar.get']('shibboleth:user', 'shibd') %}
{% set shibboleth_group = salt['pillar.get']('shibboleth:group', 'shibd') %}

include:
  - jcu.ntp

# For base packages
Shibboleth package repository:
   pkgrepo.managed:
      - name: security_shibboleth 
      - humanname: Shibboleth
      - gpgcheck: 0
      - enabled: 1 
      {% if grains['os'] == 'CentOS' %}
      - baseurl: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_CentOS-6/
      - gpgkey: http://download.opensuse.org/repositories/security:/shibboleth/CentOS_CentOS-6/repodata/repomd.xml.key 
      {% else %}
      - baseurl: http://download.opensuse.org/repositories/security:/shibboleth/RHEL_6/
      - gpgkey: http://download.opensuse.org/repositories/security:/shibboleth/RHEL_6/repodata/repomd.xml.key 
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

shibboleth configuration:
   file.managed:
      - name: /etc/shibboleth/shibboleth2.xml
      - source: salt://jcu/shibboleth/shibboleth2.xml
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - mode: 644
      - template: jinja
      - require:
         - pkg: shibboleth
         - file: shibboleth identity
         - file: /etc/shibboleth/aaf-metadata-cert.pem
         - file: /etc/shibboleth/attribute-map.xml
      - watch_in:
         - service: shibboleth

/etc/shibboleth/aaf-metadata-cert.pem:
   file.managed:
{% if salt['pillar.get']('shibboleth:test', False) %}
      - source: https://ds.aaf.edu.au/distribution/metadata/aaf-metadata-cert.pem
      - source_hash: sha256=18de1f447181033c2b91726919f51d21214f36bb450eb5988d3ebb19cd2e9ec5 
{% else %}
      - source: https://ds.test.aaf.edu.au/distribution/metadata/aaf-metadata-cert.pem
      - source_hash: sha256=76edfa8d311887a7eceee3ccbb68166a61e6301037c89e5cdf4915af372ec546
{% endif %}
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - mode: 644
      - require:
         - pkg: shibboleth

/etc/shibboleth/attribute-map.xml:
   file.managed:
      - source: salt://jcu/shibboleth/attribute-map.xml
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - mode: 644
      - require:
         - pkg: shibboleth

/usr/share/shibboleth/logo.png:
   file.managed:
      - source: salt://jcu/shibboleth/shibboleth-logo.png
      - user: root
      - group: root
      - mode: 644
      - require:
         - pkg: shibboleth

# Generate identity or manage identity files, if provided
{% if salt['pillar.get']('shibboleth:certificate', '') %}
shibboleth certificate:
   file.managed:
      - name: /etc/shibboleth/sp-cert.pem 
      - contents_pillar: 'shibboleth:certificate'
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - mode: 644
      - require:
         - pkg: shibboleth
      - require_in:
         - service: shibboleth

shibboleth identity:
   file.managed:
      - name: /etc/shibboleth/sp-key.pem
      - contents_pillar: 'shibboleth:key'
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - mode: 600
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

