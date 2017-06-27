include:
  - jcu.supervisord
  - jcu.nagios.nrpe

supervisord socket directory nrpe chgrp:
  file.directory:
    - name: /var/run/supervisor
    - group: nrpe
    - require:
      - pkg: supervisor
      - pkg: nrpe

supervisor socket nrpe chmod:
  file.managed:
    - name: /var/run/supervisor/supervisor.sock
    - replace: false
    - mode: 770
    - user: root
    - group: nrpe
    - require:
      - file: supervisord socket directory nrpe chgrp
