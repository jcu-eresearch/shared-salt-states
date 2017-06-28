include:
  - .ssl

httpd:
  pkg.installed:
    - name: httpd
  service.running:
    - enable: true
    - reload: true
    - require:
      - pkg: httpd
    - watch:
      - pkg: httpd

httpd add to firewall:
  iptables.insert:
    - table: filter
    - position: 3
    - chain: INPUT
    - jump: ACCEPT
    - proto: tcp
    - dport: 80
    - save: true
    - require:
      - service: httpd
