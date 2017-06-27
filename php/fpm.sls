php-fpm:
  pkg.installed: []
  service.running:
    - enable: true
    - onchanges:
      - pkg: php-fpm
