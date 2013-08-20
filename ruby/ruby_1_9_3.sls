install ruby_1_9_3 package dependencies:
  pkg.installed:
    - pkgs:
      - httpd-devel
      - openssl-devel
      - zlib-devel
      - gcc
      - gcc-c++
      - curl-devel
      - expat-devel
      - gettext-devel
      - patch
      - readline
      - readline-devel
      - zlib
      - zlib-devel
      - libyaml-devel
      - libffi-devel
      - make
      - bzip2
      - zlib1g

ruby_1_9_3 source:
  cmd.run:
    - name: wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz
    - cwd: /tmp/
    # Don't do this if ruby1.9.3 is already installed
    - unless: "[ -x '/usr/local/bin/ruby1.9.3' ]"


ruby_1_9_3 decompress:
  cmd.watch:
    - name: tar -xf ruby-1.9.3-p448.tar.gz
    - cwd: /tmp/
    - watch:
      - cmd: ruby_1_9_3 source

ruby_1_9_3 configure:
  cmd.watch:
    - name: ./configure --with-ruby-version=1.9.3 --prefix=/usr/local/  --program-suffix=1.9.3
    - cwd: /tmp/ruby-1.9.3-p448
    - require:
      - pkg: install ruby_1_9_3 package dependencies
    - watch:
      - cmd: ruby_1_9_3 decompress

ruby_1_9_3 make && make install:
  cmd.watch:
    - name: make && make install
    - cwd: /tmp/ruby-1-9-3-p448/
    - watch:
      - cmd: ruby_1_9_3 configure
