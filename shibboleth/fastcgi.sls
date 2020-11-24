{% set shibboleth_user = salt['pillar.get']('shibboleth:user', 'shibd') %}
{% set shibboleth_group = salt['pillar.get']('shibboleth:group', 'shibd') %}
{% set selinux = salt['grains.get']('selinux:enabled') %}

include:
  - jcu.shibboleth
  - jcu.repositories.eresearch
  - jcu.supervisord
  - jcu.nginx
  - jcu.nginx.modules.shibboleth
{% if selinux %}
  - jcu.selinux
{% endif %}

extend:
  # Install customised version supporting FastCGI
  shibboleth:
    pkg:
      - require:
        - pkgrepo: jcu-eresearch
        - pkgrepo: Shibboleth package repository

  # Prevent updating new shibboleth version with non-FastCGI package
  Shibboleth package repository:
    pkgrepo:
      - priority: 2
      - exclude: shibboleth shibboleth-devel shibboleth-debuginfo

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
  {% if selinux %}
  cmd.run:
    - name: semanage fcontext -a -t httpd_var_run_t "/opt/shibboleth(/.*)?" && restorecon -Rv /opt/shibboleth
    - require:
      - pkg: policycoreutils-python
      - file: shibboleth fastcgi
    - unless: "semanage fcontext -l | grep \"/opt/shibboleth\""
  {% endif %}

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
    {% if selinux %}
      - cmd: shibboleth fastcgi
    {% endif %}
    - listen_in:
      - service: supervisord

shibauthorizer:
  supervisord.running:
    - update: true
    - restart: true
    - require:
      - pkg: shibboleth
    - watch:
      - file: /etc/supervisord.d/shibboleth-fastcgi.ini
      - service: supervisord
    - listen:
      - service: shibboleth

shibresponder:
  supervisord.running:
    - update: true
    - restart: true
    - require:
      - pkg: shibboleth
    - watch:
      - file: /etc/supervisord.d/shibboleth-fastcgi.ini
      - service: supervisord
    - listen:
      - service: shibboleth

Shibboleth nginx config:
  file.recurse:
    - name: /etc/nginx/conf.d/snippets
    - source: salt://jcu/shibboleth/nginx/snippets
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - require:
      - sls: jcu.nginx.modules.shibboleth
      - file: nginx snippets and base configuration
      - supervisord: shibauthorizer
      - supervisord: shibresponder
    - listen_in:
      - service: nginx
