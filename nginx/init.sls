include:
  - jcu.firewall.web
  - .repo
  - .modules.headersmore
  {% if grains['os_family'] == 'RedHat' %}
  - jcu.yum.versionlock
  {% endif %}

/etc/nginx/ssl:
  file.directory:
    - makedirs: true
    - user: root
    - group: root
    - mode: 400

openssl dhparam:
  cmd.run:
{% if grains.get('insecure_encryption', False) %}
    - name: openssl dhparam -out /etc/nginx/ssl/dhparam.pem 64
{% else %}
    - name: openssl dhparam -out /etc/nginx/ssl/dhparam.pem 4096
{% endif %}
    - require:
      - file: /etc/nginx/ssl
    - unless: test -f /etc/nginx/ssl/dhparam.pem

nginx:
  pkg.installed:
  {% if grains['os_family'] == 'RedHat' %}
    {% if grains['osmajorrelease']|int == 7 %}
    - version: 1:1.12.2-1.el7_4.ngx
    {% elif grains['osmajorrelease']|int == 6 %}
    - version: 1:1.12.2-1.el6.ngx
    {% endif %}
    - hold: true
    - update_holds: true
  {% endif %}
    - require:
      - pkgrepo: nginx-repository
  service.running:
    - enable: True
    - restart: True
    - require:
      - pkg: nginx
    - watch:
      - pkg: nginx
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://jcu/nginx/nginx.conf
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - require:
      - cmd: openssl dhparam
      - pkg: nginx
    - listen_in:
      - service: nginx

# Remove default files
{% for path in ['/etc/nginx/conf.d/default.conf', '/etc/nginx/conf.d/example_ssl.conf'] %}
{{ path }}:
  file.absent:
    - require:
      - pkg: nginx
{% endfor %}

nginx snippets and base configuration:
  file.recurse:
    - name: /etc/nginx/conf.d
    - source: salt://jcu/nginx/conf.d
    - user: root
    - group: root
    - dir_mode: 400
    - file_mode: 400
    - require:
      - pkg: nginx
    - listen_in:
      - service: nginx

nginx error resources:
  file.recurse:
    - name: /usr/share/nginx/html/errors
    - source: salt://jcu/nginx/errors
    - user: root
    - group: root
    - dir_mode: 555
    - file_mode: 444
    - template: jinja
    - require:
      - pkg: nginx
      - sls: jcu.nginx.modules.headersmore

# Firewall configuration
extend:
  http iptables:
    iptables.append:
      - require:
        - pkg: nginx

  https iptables:
    iptables.append:
      - require:
        - pkg: nginx
