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
    {% if config['selfsignedcert'] %}
    - require:
      - file: {{ host }} move cert
      - file: {{ host }} move key
    {% endif %}

{% if config['selfsignedcert'] %}
{{ host }} self-signed cert:
  module.run:
    - name: tls.create_self_signed_cert
    - CN: {{ host }}
    - ca_name: "ssl"

{{ host }} move cert:
  file.rename:
    - source: "/etc/pki/tls/certs/{{ host }}.crt"
    - name: "/etc/nginx/ssl/{{ host }}.crt"
    - makedirs: true
    - require:
      - module: {{ host }} self-signed cert

{{ host }} move key:
  file.rename:
    - source: "/etc/pki/tls/certs/{{ host }}.key"
    - name: "/etc/nginx/ssl/{{ host }}.key"
    - makedirs: true
    - require:
      - module: {{ host }} self-signed cert
{% endif %}
{% endfor %}
