mariadb-server:
  pkg.installed: []
  service.running:
    - name: mariadb
    - enable: true
    - reload: true
    - onchanges:
      - pkg: mariadb-server
