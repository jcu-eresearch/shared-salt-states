php-fpm:
  pkg.installed: []
  service.running:
    - enable: True
    - restart: True
    - watch:
      - pkg: php-fpm
