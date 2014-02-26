include:
   - jcu.shibboleth
   - jcu.repositories.eresearch
   - jcu.supervisord
   - jcu.nginx.custom

{% set shibboleth_user = salt['pillar.get']('shibboleth:user', 'shibd') %}
{% set shibboleth_group = salt['pillar.get']('shibboleth:group', 'shibd') %}

# Install customised version supporting FastCGI
extend:
   shibboleth:
      pkg:
         - fromrepo: jcu-eresearch
         - require:
            - pkgrepo: jcu-eresearch 
            - pkgrepo: Shibboleth package repository 

Shibboleth Nginx snippets and configuration:
   file.recurse:
      - name: /etc/nginx/conf.d
      - source: salt://jcu/shibboleth/nginx/
      - user: nginx
      - group: nginx
      - require:
         - pkg: nginx

# Manage FastCGI applications
shibboleth fastcgi:
    file.directory:
      - name: /opt/shibboleth
      - user: {{ shibboleth_user }}
      - group: {{ shibboleth_group }}
      - makedirs: true
      - require:
        - pkg: shibboleth
    user.present:
       - name: nginx
       - groups:
          - nginx
          - shibd
       - require:
          - pkg: nginx
          - pkg: shibboleth
       - watch_in:
          - service: nginx

/etc/supervisord.d/shibboleth-fastcgi.ini:
   file.managed:
      - source: salt://jcu/shibboleth/shibboleth-fastcgi.ini
      - user: root
      - group: root
      - mode: 644
      - require:
         - user: shibboleth fastcgi
         - pkg: supervisor
         - file: shibboleth fastcgi
      - watch_in:
         - service: supervisord

shibauthorizer:
   supervisord.running:
      - update: true
      - restart: true
      - watch:
         - file: /etc/supervisord.d/shibboleth-fastcgi.ini
         - service: supervisord

shibresponder:
   supervisord.running:
      - update: true
      - restart: true
      - watch:
         - file: /etc/supervisord.d/shibboleth-fastcgi.ini
         - service: supervisord
