include:
  - jcu.repositories.remi
  - jcu.nginx

Install nginx php support packages:
  pkg.installed:
    - pkgs:
      - php-fpm
      - php-common
    - require:
      - pkg: remi
      - pkg: nginx
    - watch_in:
      - service: nginx
