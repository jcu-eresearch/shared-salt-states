include:
  - jcu.nginx
  - jcu.repositories.eresearch

nginx-module-fancyindex:
  pkg.installed:
    - require:
      - pkg: nginx
      - pkgrepo: jcu-eresearch
    - watch_in:
      - service: nginx
