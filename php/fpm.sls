php-fpm:
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - pkg: php-fpm
