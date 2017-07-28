include:
  - jcu.nginx
  - jcu.shibboleth

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
      - pkg: shibboleth
    - listen_in:
      - service: nginx

