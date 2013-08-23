include:
  - jcu.ruby.rvm.ruby_1_9_3

passenger:
  gem.installed:
    - runas: rvm
    - ruby: ruby-1.9.3
    - require:
      - rvm: ruby-1.9.3

/etc/init.d/nginx:
  file.managed:
    - source:
      - salt://jcu/ruby/rvm/ruby_1_9_3/nginx_initd
    - user: root
    - group: root
    - mode: 740

/usr/local/nginx:
  file.directory:
    - user: rvm
    - group: rvm
    - makedirs: True
    - mode: 744
    - require:
      - user: rvm

/usr/local/nginx/conf/conf.d:
  file.directory:
    - user: rvm
    - group: rvm
    - makedirs: True
    - mode: 744
    - require:
      - user: rvm

/usr/local/nginx/conf/nginx.conf:
  file.managed:
    - source:
      - salt://jcu/ruby/rvm/ruby_1_9_3/nginx_config.conf
    - user: rvm
    - group: rvm
    - mode: 740
    - require:
      - user: rvm

nginx:
  module.run:
    - name: rvm.do
    - ruby: ruby-1.9.3
    - runas: rvm
    - command: passenger-install-nginx-module --auto --auto-download --prefix=/usr/local/nginx --extra-configure-flags="--user=rvm"
    - require:
      - gem: passenger
      - file: /usr/local/nginx
    - require_in:
      - file: /home/rvm
  service:
    - running
    - enable: True
    - watch:
      - module: nginx
      - file: /etc/init.d/nginx


add nginx to firewall:
  module.wait:
    - name: iptables.insert
    - table: filter
    - chain: INPUT
    - position: 3
    - rule: -p tcp --dport 80 -j ACCEPT
    - watch_in:
      - module: save iptables
    - watch:
      - module: nginx

save iptables:
  module.wait:
    - name: iptables.save
    - filename: /etc/sysconfig/iptables
