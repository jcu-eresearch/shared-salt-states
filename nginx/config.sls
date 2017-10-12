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
    - listen_in:
      - service: nginx

{% endfor %}
