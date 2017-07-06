include:
  - jcu.shibboleth
  - jcu.nginx.custom

Shibboleth DS Nginx snippet:
  file.managed:
    - name: /etc/nginx/conf.d/snippets/shibboleth-ds
    - source: salt://jcu/shibboleth/nginx/shibboleth-ds
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - require:
      - pkg: nginx
    - listen_in:
      - service: nginx

