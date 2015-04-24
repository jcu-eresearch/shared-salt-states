include:
  - jcu.repositories.epel

bash-completion:
  pkg.installed:
    - require:
      - pkg: epel
