include:
  - jcu.nginx
  - jcu.php.fpm

extend:
  php-fpm:
    pkg.installed:
      - require_in:
        - pkg: nginx
    service.running:
      - watch_in:
        - service: nginx

php nginx configuration snippets:
  file.recurse:
    - name: /etc/nginx/conf.d/snippets
    - source: salt://jcu/nginx/php_snippets
    - user: root
    - group: root
    - require:
      - file: nginx snippets and base configuration
      - pkg: php-fpm
