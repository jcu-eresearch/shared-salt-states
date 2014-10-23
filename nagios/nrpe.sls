nrpe:
  pkg:
    - installed
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: nrpe

nrpe configuration:
  file.managed:
    - name: /etc/nagios/nrpe.cfg
    - source: salt://jcu/nagios/nrpe.cfg
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: nrpe
    - watch_in:
      - service: nrpe

'chcon -u system_u /usr/local/lib/nagios/plugins/*':
  cmd.run:
    - require:
      - pkg: nrpe

'chcon -t nagios_system_plugin_exec_t /usr/local/lib/nagios/plugins/*':
  cmd.run:
    - require:
      - pkg: nrpe

