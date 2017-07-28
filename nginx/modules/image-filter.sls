include:
  - jcu.nginx
  - jcu.nginx.repo

nginx-module-image-filter:
  pkg.installed:
    - require:
      - pkg: nginx
      - pkgrepo: nginx-repository
    - watch_in:
      - service: nginx
