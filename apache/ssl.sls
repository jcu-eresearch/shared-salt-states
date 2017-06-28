mod_ssl:
  pkg.installed:
    - watch_in:
      - service: httpd

mod_ssl add to firewall:
  iptables.insert:
    - table: filter
    - position: 3
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 443
    - save: true
    - require:
      - service: httpd

