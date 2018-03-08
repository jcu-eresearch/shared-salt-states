include:
  - jcu.nodejs
  - jcu.repositories.yarn

yarn:
  pkg.installed:
    - require:
      - pkg: nodejs
      - pkgrepo: yarn repo
