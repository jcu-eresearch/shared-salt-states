include:
  - jcu.development_tools

rvm:
  group:
    - present
  user.present:
    - fullname: rvm
    - usergroup: True
    - home: /home/rvm
    - shell: /bin/bash
    - groups:
      - wheel
      - rvm
    - require:
      - group: rvm
      - file: /etc/sudoers.d/rvm

/home/rvm:
  file.directory:
    - user: rvm
    - dir_mode: 755
    - recurse:
      - mode
    - require:
      - user: rvm

/etc/sudoers.d/rvm:
  file.managed:
    - source:
      - salt://jcu/ruby/rvm/rvm_sudoers
    - user: root
    - group: root
    - mode: 330

rvm-deps:
  pkg.installed:
    - names:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git
      - subversion

mri-deps:
  pkg.installed:
    - names:
      - libffi-devel
      - openssl-devel
      - readline-devel
      - libcurl-devel
      - git
      - zlib-devel
      - openssl-devel
      - libyaml-devel
      - sqlite-devel
      - libxml2-devel
      - libxslt-devel
      - autoconf
      - ncurses-devel
      - automake
      - libtool
      - bison
      - subversion
      - ruby
    - require:
      - pkg: Development Tools
