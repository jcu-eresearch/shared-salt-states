include:
  - jcu.php
  - jcu.php.json

composer:
  file.managed:
    - name: /root/composer-installer
    - source: https://raw.githubusercontent.com/composer/getcomposer.org/4074853c4cb6f2438a145ccd5863dbd78496383a/web/installer
    - source_hash: sha384=795f976fe0ebd8b75f26a6dd68f78fd3453ce79f32ecb33e7fd087d39bfeb978342fb73ac986cd4f54edd0dc902601dc
    - unless: test -f /usr/bin/composer
  cmd.wait:
    - name: php /root/composer-installer --install-dir=/usr/bin/ --filename=composer
    - cwd: /root/
    - unless: test -f /usr/bin/composer
    - require:
      - pkg: php
    - watch:
      - file: composer

Remove Composer installer:
  file.absent:
    - name: '/root/composer-installer'
    - require:
      - cmd: composer

{% for install_directory in salt['pillar.get']('php:composer:install_directories', []) %}
{{ install_directory }} composer install:
  composer.installed:
    - name: {{ install_directory }}
    - composer: /usr/bin/composer
    - require:
      - file: Remove Composer installer
      - git: OJS installation
{% endfor %}
