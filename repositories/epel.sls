{% if grains['os_family'] == 'RedHat' %}
{% if grains['osfinger'] == 'Red Hat Enterprise Linux-8' %}
include:
  - .codeready_linux_builder
{% elif grains['osfinger'] == 'CentOS Linux-8' %}
include:
  - .powertools
{% endif %}

epel:
  pkg.installed:
    - name: epel-release
    - unless: rpm -q epel-release
  {% if grains['osfinger'] == 'Red Hat Enterprise Linux-8' %}
    - sources:
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    - require:
      - cmd: codeready linux builder repo
  {% elif grains['osfinger'] == 'CentOS Linux-8' %}
    - require:
      - cmd: powertools repo
  {% elif grains['osfinger'] == 'Red Hat Enterprise Linux Server-7' %}
    - sources:
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  {% elif grains['osfinger'] == 'Red Hat Enterprise Linux Server-6' %}
    - sources:
      - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
  {% endif %}
{% endif %}
