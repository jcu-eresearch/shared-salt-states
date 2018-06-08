include:
  - jcu.repositories.eresearch

{% if grains['os_family'] == 'RedHat' %}
veeam-release-el{{ grains['osmajorrelease'] }}:
  pkg.installed:
    - require:
      - pkgrepo: jcu-eresearch
{% endif %}
