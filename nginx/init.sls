include:
  - jcu.firewall.web

nginx-repository:
  pkgrepo.managed:
    - name: nginx
    - humanname: nginx repo
    - baseurl: http://nginx.org/packages/{{ 'centos' if grains['os'] == 'CentOS' else 'rhel' }}/{{ grains['osmajorrelease'] }}/$basearch/
    - gpgcheck: 0
    - enabled: 1

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
    - require:
      - pkgrepo: nginx-repository
  service.running:
    - enable: True
    - reload: True
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
    - watch_in:
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
    - watch_in:
      - service: nginx

nginx error resources:
  file.recurse:
    - name: /usr/share/nginx/html/errors
    - source: salt://jcu/nginx/errors
    - user: root
    - group: root
    - dir_mode: 400
    - file_mode: 400
    - template: jinja
    - require:
      - pkg: nginx

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
