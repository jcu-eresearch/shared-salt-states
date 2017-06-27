php-fpm:
  pkg.installed: []
  service.running:
    - enable: true
    - reload: true
    - onchanges:
      - pkg: php-fpm
