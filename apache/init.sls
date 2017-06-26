include:
  - .ssl

httpd:
  pkg.installed:
    - name: httpd
  service:
    - running
    - enable: True
    - require:
      - pkg: httpd
    - watch:
      - pkg: httpd

httpd add to firewall:
  module.wait:
    - name: iptables.insert
    - table: filter
    - chain: INPUT
    - position: 3
    - rule: -p tcp --dport 80 -j ACCEPT
    - watch_in:
      - module: save httpd iptables

save httpd iptables:
  module.run:
    - name: iptables.save
    - filename: /etc/sysconfig/iptables

