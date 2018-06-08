{% if grains['os_family'] == 'RedHat' %}
yarn repo:
  pkgrepo.managed:
    - name: yarn
    - humanname: Yarn Repository
    - baseurl: https://dl.yarnpkg.com/rpm/
    - gpgcheck: 1
    - gpgkey: https://dl.yarnpkg.com/rpm/pubkey.gpg
    - enabled: 1
{% endif %}

