include:
   - .
   - jcu.repositories.eresearch
   - jcu.supervisord

{% set shibboleth_user = salt['pillar.get']('shibboleth:user', 'shibd') %}
{% set shibboleth_group = salt['pillar.get']('shibboleth:group', 'shibd') %}

# Install customised version supporting FastCGI
extend:
   shibboleth:
      pkg:
         - fromrepo: jcu-eresearch
         - require:
            - pkgrepo: jcu-eresearch 
            - file: Shibboleth package repository 

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
