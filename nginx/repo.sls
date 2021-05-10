{% if grains['os_family'] == 'RedHat' %}
nginx-repository:
  pkgrepo.managed:
    - name: nginx-stable
    - humanname: nginx stable repo
    - baseurl: https://nginx.org/packages/rhel/$releasever/$basearch/
    - gpgcheck: 1
    - enabled: 1
    - gpgkey: https://nginx.org/keys/nginx_signing.key
    - module_hotfixes: true
{% endif %}
