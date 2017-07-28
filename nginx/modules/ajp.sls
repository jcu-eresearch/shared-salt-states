include:
  - jcu.nginx
  - jcu.repositories.eresearch

nginx-module-ajp:
  pkg.installed:
    - require:
      - pkg: nginx
      - pkgrepo: jcu-eresearch
    - watch_in:
      - service: nginx
