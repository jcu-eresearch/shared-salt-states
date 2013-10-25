nginx-repository:
   pkgrepo.managed:
      - name: nginx
      - humanname: nginx repo
      - baseurl: http://nginx.org/packages/{{ 'centos' if grains['os'] == 'CentOS' else 'rhel' }}/{{ grains['osmajorrelease'][0] }}/$basearch/ 
      - gpgcheck: 0
      - enabled: 1 

nginx:
   pkg.installed: 
      - require:
           - pkgrepo: nginx-repository
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
