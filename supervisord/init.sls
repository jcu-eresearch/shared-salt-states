include:
    - jcu.repositories.epel

supervisor:
  pkg.installed:
    - refresh: true
    - require:
      - pkg: epel

supervisord:
  service.running:
    - enable: True
    - require:
      - pkg: supervisor
