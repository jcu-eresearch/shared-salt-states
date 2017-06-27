# Pillar should look like the following:
# nginx:
#   hosts:
#     my.example.org:
#       config: salt://path/hostname.conf
include:
  - jcu.nginx

{% for host, config in pillar['nginx']['hosts'].items() %}

{{ host }} web config:
  file.managed:
    - name: /etc/nginx/conf.d/{{ host }}.conf
    - source: {{ config['config'] }}
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - onchanges_in:
      - service: nginx

{{ host }} ssl certificate:
  file.managed:
    - name: /etc/nginx/ssl/{{ host }}.crt
    - makedirs: true
    - user: root
    - group: root
    - mode: 400
    - contents_pillar: 'nginx:certificate'
    - require:
      - pkg: nginx
    - onchanges_in:
      - service: nginx

{{ host }} ssl key:
  file.managed:
    - name: /etc/nginx/ssl/{{ host }}.key
    - makedirs: true
    - user: root
    - group: root
    - mode: 400
    - contents_pillar: 'nginx:key'
    - require:
      - pkg: nginx
    - onchanges_in:
      - service: nginx

{% endfor %}
