include:
  - jcu.php
  - jcu.apache

extend:
  httpd:
    service.running:
      - require:
        - pkg: php
