rpm-plugin-versionlock:
   pkg.installed:
     {% if grains['osmajorrelease']|int >= 8 %}
     - name: python3-dnf-plugin-versionlock
     {% elif grains['osmajorrelease']|int <= 7 %}
     - name: yum-plugin-versionlock
     {% endif %}
