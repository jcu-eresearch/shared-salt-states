include:
  - jcu.apache

php:
  pkg.installed:
    - watch_in:
      - service: httpd
