include:
  - jcu.nginx
  - jcu.nginx.repo

nginx-module-geoip:
  pkg.installed:
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
