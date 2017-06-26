mariadb-server:
  pkg.installed: []
  service.running:
    - name: mariadb
    - enable: true
    - reload: true
    - watch:
      - pkg: mariadb-server
