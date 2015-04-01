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
      - require:
        - pkgrepo: jcu-eresearch 
        - pkgrepo: Shibboleth package repository 

# Prevent updating new shibboleth version with non-FastCGI package
extend:
  Shibboleth package repository:
    pkgrepo:
      - exclude: shibboleth shibboleth-debug

Shibboleth Nginx config:
  file.recurse:
    - name: /etc/nginx/conf.d/snippets
    - source: salt://jcu/shibboleth/nginx/snippets
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - require:
      - file: nginx snippets and base configuration
    - watch_in:
      - service: nginx

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
