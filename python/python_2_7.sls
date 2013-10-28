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
    - name: wget http://python.org/ftp/python/2.7.5/Python-2.7.5.tar.bz2
    - cwd: /tmp/
    # Don't do this if python2.7 is already installed
    - unless: test -f /tmp/Python-2.7.5.tar.bz2

python_2_7 decompress:
  cmd.run:
    - name: tar -xf Python-2.7.5.tar.bz2
    - cwd: /tmp/
    - watch:
      - cmd: python_2_7 source
    - unless: test -d /tmp/Python-2.7.5

python_2_7 configure:
  cmd.run:
    - name: ./configure --prefix=/usr/local/
    - cwd: /tmp/Python-2.7.5/
    - require:
      - pkg: python_2_7 package dependencies
      - cmd: python_2_7 decompress
    - unless: test -x /usr/local/bin/python2.7

python_2_7 make && make altinstall:
  cmd.run:
    - name: make && make altinstall
    - cwd: /tmp/Python-2.7.5/
    - require:
      - cmd: python_2_7 configure
    - unless: test -x /usr/local/bin/python2.7
