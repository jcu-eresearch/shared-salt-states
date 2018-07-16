include:
  - jcu.repositories.epel
  - jcu.apache
  - jcu.certbot.cron

python2-certbot-apache:
  pkg.installed:
    - require:
      - pkg: epel
      - pkg: httpd

certbot apache:
  cmd.run:
    - name: certbot --apache --non-interactive
    - require:
      - service: httpd
      - pkg: python2-certbot-apache
      - file: certbot configuration
    - require_in:
      - cron: certbot cron
