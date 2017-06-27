# https://ius.io/ - Inline with Upstream Stable
# IUS is a community project that provides RPM packages for newer versions of
# select software for Enterprise Linux distributions.

{% if grains['os_family'] == 'RedHat' %}
include:
  - .epel

ius:
  pkg.installed:
    - name: ius-release
    - require:
      - pkg: epel
    - unless: rpm -q ius-release
    - sources:
    {% if grains['osfinger'] == 'Red Hat Enterprise Linux Server-7' %}
      - ius-release: https://rhel7.iuscommunity.org/ius-release.rpm
    {% elif grains['osfinger'] == 'CentOS Linux-7' %}
      - ius-release: https://centos7.iuscommunity.org/ius-release.rpm
    {% elif grains['osfinger'] == 'Red Hat Enterprise Linux Server-6' %}
      - ius-release: https://rhel6.iuscommunity.org/ius-release.rpm
    {% elif grains['osfinger'] == 'CentOS-6' %}
      - ius-release: https://centos6.iuscommunity.org/ius-release.rpm
  {% endif %}
{% endif %}
