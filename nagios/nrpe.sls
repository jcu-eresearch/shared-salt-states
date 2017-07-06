include:
  - jcu.repositories.epel
  - jcu.repositories.eresearch

nrpe-plugin:
  pkg.installed:
    - require:
      - pkgrepo: jcu-eresearch

nagios-common:
  pkg.installed:
    - require:
      - pkg: epel

nrpe:
  pkg.installed:
    - require:
      - pkg: epel
      - pkg: nrpe-plugin
      - pkg: nagios-common
  service.running:
    - enable: True
    - full_restart: True
    - watch:
      - pkg: nrpe

ksh:
  pkg.installed

nagios plugins:
  pkg.installed:
    - pkgs:
      - nagios-plugins-load
      - nagios-plugins-disk
      - nagios-plugins-ntp
      - nagios-plugins-file_age

custom nagios plugins:
  file.recurse:
    - name: /usr/local/lib/nagios/plugins
    - source: salt://jcu/nagios/plugins
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755
    - require:
      - pkg: ksh

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
      - pkg: nagios plugins
      - file: custom nagios plugins
    - listen_in:
      - service: nrpe

nrpe firewall configuration:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 5666
    - source: 137.219.15.0/24
    #- comment: Allow Nagios
    - save: True
    - require:
      - file: nrpe configuration
