include:
  - jcu.repositories.epel
  - jcu.apache

python2-certbot-apache:
  pkg.installed:
    - require:
      - pkg: epel
      - pkg: httpd

certbot apache:
  cmd.run:
    - name: certbot --apache --non-interactive
    - require:
      - pkg: python2-certbot-apache
      - file: certbot configuration
      - service: httpd
    - require_in:
      - cron: certbot cron