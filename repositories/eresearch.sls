{% if grains['os_family'] == 'RedHat' %}
include:
  - jcu.yum.protectbase

jcu-eresearch:
  pkgrepo.managed:
    - humanname: JCU eResearch EL Custom Repo
    {% if grains['osmajorrelease']|int == 7 %}
    - baseurl: https://www.hpc.jcu.edu.au/repos/jcu_eresearch/centos-7/
    {% elif grains['osmajorrelease']|int == 6 %}
    - baseurl: https://www.hpc.jcu.edu.au/repos/jcu_eresearch/centos-6/
    {% endif %}
    - gpgcheck: 0
    - priority: 1
    - enabled: 1
    - protected: 1
    - require:
      - pkg: yum-plugin-protectbase
{% endif %}
