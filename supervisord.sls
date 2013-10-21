include:
    - jcu.repositories.epel

supervisor:
  pkg.installed:
    - require:
      - pkg: epel 

supervisord:
  service:
    - running
    - enable: True
    - require:
      - pkg: supervisor
