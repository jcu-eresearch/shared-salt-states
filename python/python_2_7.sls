#Note that existing Python installations will not be upgraded unless the old
#interpreter is removed.
{% set version = '2.7.6' %}

include:
  - jcu.development_tools

python_2_7 package dependencies:
  pkg.installed:
    - names:
      - zlib-devel
      - bzip2-devel
      - openssl-devel
      - ncurses-devel
      - sqlite-devel
      - readline-devel
      - tk-devel
    - require:
      - module: Development Tools

# Starts a chain of events which results in the altinstall of python to /usr/local
python_2_7 source:
  cmd.run:
    - name: wget http://python.org/ftp/python/{{ version }}/Python-{{ version }}.tar.bz2
    - cwd: /tmp/
    # Don't do this if python2.7 is already installed
    - unless: test -x /usr/local/bin/python2.7 || test -f /tmp/Python-{{ version }}.tar.bz2 

python_2_7 decompress:
  cmd.wait:
    - name: tar -xf Python-{{ version }}.tar.bz2
    - cwd: /tmp/
    - watch:
      - cmd: python_2_7 source
    - unless: test -d /tmp/Python-{{ version }}

python_2_7 configure:
  cmd.wait:
    - name: ./configure --prefix=/usr/local/
    - cwd: /tmp/Python-{{ version }}/
    - require:
      - pkg: python_2_7 package dependencies
    - watch: 
      - cmd: python_2_7 decompress
    - unless: test -x /usr/local/bin/python2.7

python_2_7:
  cmd.wait:
    - name: make && make altinstall
    - cwd: /tmp/Python-{{ version }}/
    - watch:
      - cmd: python_2_7 configure
    - unless: test -x /usr/local/bin/python2.7

