include:
  - jcu.development_tools

rvm:
  group:
    - present
  user.present:
    - gid: rvm
    - home: /home/rvm
    - require:
      - group: rvm

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
      - cmd: Development Tools
