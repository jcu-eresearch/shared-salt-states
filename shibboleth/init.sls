include:
   - jcu.repositories.eresearch
   - jcu.supervisord

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

# Install customised version supporting FastCGI
shibboleth:
   pkg:
      - installed
      - fromrepo: jcu-eresearch
      - require:
         - pkgrepo: jcu-eresearch 
         - file: Shibboleth package repository 
   service:
      - running
      - name: shibd
      - enable: True
      - require:
         - pkg: shibboleth 

# Generate identity or manage identity files, if provided
{% if salt['pillar.get']('shibboleth:certificate', '') %}
# XXX This doesn't work because we can't reference pillar files...
shibboleth certificate:
   file.managed:
      - name: /etc/shibboleth/sp-cert.pem 
      - contents_pillar: 'shibboleth:certificate'
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - mode: 644

shibboleth identity:
   file.managed:
      - name: /etc/shibboleth/sp-key.pem
      - contents_pillar: 'shibboleth:key'
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - mode: 600
      - require:
         - file: shibboleth certificate
{% else %}
shibboleth identity creation:
   cmd.run:
      - name: >
                /etc/shibboleth/keygen.sh -o /etc/shibboleth/ 
                -u '{{ shibboleth_user }}'
                -g '{{ shibboleth_group }}'
                -h '{{ pillar['shibboleth']['host'] }}'
                -e '{{ pillar['shibboleth']['entityid'] }}'
      - unless: test -r /etc/shibboleth/sp-cert.pem || test -r /etc/shibboleth/sp-key.pem 

shibboleth identity:
    file.exists:
      - name: /etc/shibboleth/sp-cert.pem
{% endif %}

shibboleth configuration:
   file.managed:
      - name: /etc/shibboleth/shibboleth2.xml
      - contents: 'Test'
      - mode: 644
      - require:
         - file: shibboleth identity

# Manage FastCGI applications
/opt/shibboleth:
    file.directory:
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}

/etc/supervisord.d/shibboleth-fastcgi.ini:
   file.managed:
      - source: salt://jcu/shibboleth/shibboleth-fastcgi.ini
      - user: root
      - group: root
      - mode: 644
      - requires:
         - pkg: supervisord
         - pkg: shibboleth
         - file: /opt/shibboleth
      - watch_in:
         - service: supervisord

shibauthorizer:
   supervisord.running:
      - update: true
      - watch:
         - file: /etc/supervisord.d/shibboleth-fastcgi.ini

shibresponder:
   supervisord.running:
      - update: true
      - watch:
         - file: /etc/supervisord.d/shibboleth-fastcgi.ini
