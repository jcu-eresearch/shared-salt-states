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
    - mode: 731

nginx:
  module.run:
    - name: rvm.do
    - ruby: ruby-1.9.3
    - runas: rvm
    - command: rvmsudo passenger-install-nginx-module --auto --auto-download --prefix=/usr/local/nginx
    - watch:
      - gem: passenger
    - unless: test -x /usr/local/nginx/sbin/nginx
  service:
    - running
    - enable: True
    - watch:
      - module: nginx
      - file: /etc/init.d/nginx
