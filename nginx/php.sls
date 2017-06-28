include:
  - jcu.nginx
  - jcu.php.fpm

extend:
  nginx:
    pkg.installed:
      - require:
        - pkg: php-fpm
    service.running:
      - watch:
        - service: php-fpm

php nginx configuration snippets:
  file.recurse:
    - name: /etc/nginx/conf.d/snippets
    - source: salt://jcu/nginx/php_snippets
    - user: root
    - group: root
    - require:
      - file: nginx snippets and base configuration
      - pkg: php-fpm
