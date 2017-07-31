install ruby_1_9_3 package dependencies:
  pkg.installed:
    - pkgs:
      - httpd-devel
      - openssl-devel
      - zlib-devel
      - gcc
      - gcc-c++
      - libcurl-devel
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

ruby_1_9_3 source:
  cmd.run:
    - name: wget https://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz
    - cwd: /tmp/
    # Don't do this if ruby1.9.3 is already installed
    - unless: test -f /tmp/ruby-1.9.3-p448.tar.gz


ruby_1_9_3 decompress:
  cmd.run:
    - name: tar -xf ruby-1.9.3-p448.tar.gz
    - cwd: /tmp/
    - require:
      - cmd: ruby_1_9_3 source
    - unless: test -d /tmp/ruby-1.9.3-p448

ruby_1_9_3 configure:
  cmd.run:
    - name: ./configure --with-ruby-version=1.9.3 --prefix=/usr/local/  --program-suffix=1.9.3
    - cwd: /tmp/ruby-1.9.3-p448
    - require:
      - pkg: install ruby_1_9_3 package dependencies
      - cmd: ruby_1_9_3 decompress
    - unless: test -x /usr/local/bin/ruby1.9.3

ruby_1_9_3 make && make install:
  cmd.run:
    - name: make && make install
    - cwd: /tmp/ruby-1.9.3-p448
    - require:
      - cmd: ruby_1_9_3 configure
    - unless: test -x /usr/local/bin/ruby1.9.3
