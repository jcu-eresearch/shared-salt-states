mod_ssl:
  pkg.installed:
    - watch_in:
      - service: httpd

mod_ssl add to firewall:
  module.wait:
    - name: iptables.insert
    - table: filter
    - chain: INPUT
    - position: 3
    - rule: -p tcp --dport 443 -j ACCEPT
    - watch_in:
      - module: save httpd iptables
