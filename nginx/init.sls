include:
   - jcu.repositories.eresearch

nginx:
   pkg.installed:
      - fromrepo: jcu-eresearch
      - require:
          - pkgrepo: jcu-eresearch
   service.running:
      - enable: True
      - reload: True
      - watch:
          - pkg: nginx

# Firewall configuration
http iptables:
   module.run:
      - name: iptables.insert
      - table: filter
      - chain: INPUT
      - position: 3
      - rule: -p tcp --dport 80 -j ACCEPT

https iptables:
   module.run:
      - name: iptables.insert
      - table: filter
      - chain: INPUT
      - position: 3
      - rule: -p tcp --dport 443 -j ACCEPT
