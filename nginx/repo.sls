{% if grains['os_family'] == 'RedHat' %}
# CentOS and RHEL packages are currently the same for nginx
nginx-repository:
  pkgrepo.managed:
    - name: nginx
    - humanname: nginx repo
    - baseurl: https://nginx.org/packages/centos/{{ grains['osmajorrelease'] }}/$basearch/
    - gpgcheck: 0
    - enabled: 1
{% endif %}
