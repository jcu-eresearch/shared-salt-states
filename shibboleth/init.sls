{% set shibboleth_user = salt['pillar.get']('shibboleth:user', 'shibd') %}
{% set shibboleth_group = salt['pillar.get']('shibboleth:group', 'shibd') %}

# For base packages
Shibboleth package repository:
   file.managed:
      - name: /etc/yum.repos.d/security:shibboleth.repo
      - source: http://download.opensuse.org/repositories/security://shibboleth/RHEL_6/security:shibboleth.repo
      - source_hash: sha256=4279b0d9725d94f5ceeb9b4f10f4e9e7c0c306752605b154adaff5343b3236ab
      - user: root
      - group: root
      - mode: 644

shibboleth:
   pkg.installed:
      - require:
         - file: Shibboleth package repository 
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
      - defaults: 
         shibboleth: {{ pillar['shibboleth']|yaml }}
      - require:
         - file: shibboleth identity
         - file: /etc/shibboleth/aaf-metadata-cert.pem
      - watch_in:
         - service: shibboleth

/etc/shibboleth/aaf-metadata-cert.pem:
   file.managed:
      - source: https://ds.aaf.edu.au/distribution/metadata/aaf-metadata-cert.pem
      - source_hash: sha256=18de1f447181033c2b91726919f51d21214f36bb450eb5988d3ebb19cd2e9ec5 
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
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

shibboleth identity:
    file.exists:
      - name: /etc/shibboleth/sp-cert.pem
      - require:
           - cmd: shibboleth identity creation
{% endif %}

