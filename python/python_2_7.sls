#Note that existing Python installations will not be upgraded unless the old
#interpreter is removed.
{% set version = '2.7.13' %}

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
      - pkg: Development Tools

# Starts a chain of events which results in the altinstall of python to /usr/local
python_2_7 install dependencies:
  pkg.installed:
    - names:
      - wget

python_2_7 source:
  cmd.run:
    - name: wget https://python.org/ftp/python/{{ version }}/Python-{{ version }}.tgz
    - cwd: /tmp/
    - require:
      - pkg: python_2_7 install dependencies
    # Don't do this if python2.7 is already installed
    - unless: test -x /usr/local/bin/python2.7 || test -f /tmp/Python-{{ version }}.tgz

python_2_7 decompress:
  cmd.wait:
    - name: tar -xf Python-{{ version }}.tgz
    - cwd: /tmp/
    - onchanges:
      - cmd: python_2_7 source
    - unless: test -d /tmp/Python-{{ version }}

python_2_7 configure:
  cmd.wait:
    - name: ./configure --prefix=/usr/local/
    - cwd: /tmp/Python-{{ version }}/
    - require:
      - pkg: python_2_7 package dependencies
    - onchanges:
      - cmd: python_2_7 decompress
    - unless: test -x /usr/local/bin/python2.7

python_2_7:
  cmd.wait:
    - name: make && make altinstall
    - cwd: /tmp/Python-{{ version }}/
    - onchanges:
      - cmd: python_2_7 configure
    - unless: test -x /usr/local/bin/python2.7

