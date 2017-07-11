include:
  - jcu.repositories.epel
  - jcu.apache

python2-certbot-apache:
  pkg.installed:
    - require:
      - pkg: epel
      - pkg: apache
