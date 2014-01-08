include:
  - jcu.ruby.rvm

ruby-1.9.3:
  rvm.installed:
    - name: ruby-1.9.3-p484
    - default: True
    - runas: rvm
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps
      - user: rvm

bundler:
  gem.installed:
    - runas: rvm
    - ruby: ruby-1.9.3
    - require:
      - rvm: ruby-1.9.3
