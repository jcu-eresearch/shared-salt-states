php-fpm:
  pkg.installed: []
  service.running:
    - enable: true
    - watch:
      - pkg: php-fpm
