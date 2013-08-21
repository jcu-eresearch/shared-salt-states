include:
  - jcu.ruby.ruby_1_9_3

install passenger:
  cmd.run:
    - name: /usr/local/bin/gem1.9.3 install passenger
    - require:
      - cmd: ruby_1_9_3 make && make install
    - unless: test -x /usr/local/bin/passenger-install-nginx-module

install nginx-module:
  cmd.wait:
    - name: /usr/local/bin/passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx
    - watch:
      - cmd: install passenger
    - unless: test -d /opt/nginx
