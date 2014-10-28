nrpe-plugin:
  pkg.installed

nagios-common:
  pkg.installed

nrpe:
  pkg.installed:
    - require:
      - pkg: nrpe-plugin
      - pkg: nagios-common
  service.running:
    - enable: True
    - full_restart: True
    - watch:
      - pkg: nrpe

ksh:
  pkg.installed

custom nagios plugins:
  file.exists:
    - name: /usr/local/lib/nagios
    - require:
      - pkg: ksh

'chcon -u system_u /usr/local/lib/nagios/plugins/*':
  cmd.run:
    - require:
      - file: nagios plugins

'chcon -t nagios_system_plugin_exec_t /usr/local/lib/nagios/plugins/*':
  cmd.run:
    - require:
      - file: nagios plugins

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
      - file: custom nagios plugins
    - watch_in:
      - service: nrpe

nrpe firewall configuration:
  iptables.append:
    - table: filter
    - chain: NEW
    - jump: ACCEPT
    - proto: tcp
    - dport: 5666
    - source: 137.219.15.0/24
    - save: True
    - require:
      - file: nrpe configuration

