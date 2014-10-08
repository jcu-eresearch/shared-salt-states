# Any of these files could be templated if required
{% set host = pillar['nginx']['host'] %}

include:
  - jcu.nginx

{{ host }} web configuration:
  file.managed:
    - name: /etc/nginx/conf.d/{{ host }}.conf
    - source: {{ pillar['nginx']['configuration'] }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
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
    - watch_in:
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
    - watch_in:
      - service: nginx
