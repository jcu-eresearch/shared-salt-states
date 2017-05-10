include:
  - jcu.supervisord
  - jcu.nagios.nrpe

supervisord socket directory nrpe chgrp:
  file.directory:
    - name: /var/run/supervisor
    - group: nagios
    - require:
      - pkg: supervisor
      - pkg: nrpe

supervisor socket nrpe chmod:
  file.managed:
    - name: /var/run/supervisor/supervisor.sock
    - mode: 770
    - user: root
    - group: nagios
    - require:
      - file: supervisord socket directory nrpe chgrp
