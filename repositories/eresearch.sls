{% if grains['os_family'] == 'RedHat' %}
include:
  - jcu.yum.protectbase

jcu-eresearch:
  pkgrepo.managed:
    - humanname: JCU eResearch EL Custom Repo
    {% if grains['osmajorrelease'] == '7' %}
    - baseurl: https://www.hpc.jcu.edu.au/repos/jcu_eresearch/CentOS_7/
    {% elif grains['osmajorrelease'] == '6' %}
    - baseurl: https://www.hpc.jcu.edu.au/repos/jcu_eresearch/CentOS_6/
    {% endif %}
    - gpgcheck: 0
    - priority: 1
    - enabled: 1
    - protected: 1
    - require:
      - pkg: yum-plugin-protectbase
{% endif %}
