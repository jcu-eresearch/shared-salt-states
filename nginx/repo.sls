{% if grains['os_family'] == 'RedHat' %}
# CentOS and RHEL packages are currently the same for nginx
nginx-repository:
  pkgrepo.managed:
    - name: nginx-stable
    - humanname: nginx stable repo
    - baseurl: https://nginx.org/packages/centos/$releasever/$basearch/
    - gpgcheck: 1
    - enabled: 1
    - gpgkey: https://nginx.org/keys/nginx_signing.key
    - module_hotfixes: true
{% endif %}
