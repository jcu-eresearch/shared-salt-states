include:
    - jcu.repositories.epel
    - jcu.repositories.eresearch

supervisor:
  pkg.installed:
    - refresh: true
    - fromrepo: jcu-eresearch
    - require:
      - pkgrepo: jcu-eresearch
      - pkg: epel

supervisord:
  service:
    - running
    - enable: True
    - require:
      - pkg: supervisor
