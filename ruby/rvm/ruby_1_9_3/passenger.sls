include:
  - jcu.ruby.rvm.ruby_1_9_3

passenger:
  gem.installed:
    - runas: rvm
    - ruby: ruby-1.9.3
    - require:
      - rvm: ruby-1.9.3

/opt/nginx:
  file.directory:
    - user: rvm
    - group: rvm
    - mode: 755
    - makedirs: True

install nginx-module:
  module.run:
    - name: rvm.do
    - ruby: ruby-1.9.3
    - runas: rvm
    - command: passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx
    - require:
      - file: /opt/nginx
    - watch:
      - gem: passenger
    - unless: test -x /opt/nginx/sbin/nginx
