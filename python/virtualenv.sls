virtualenv:
  pkg.installed:
    {% if grains['osmajorrelease']|int >= 8 %}
    - name: python3-virtualenv
    {% elif grains['osmajorrelease']|int <= 7 %}
    - name: python-virtualenv
    {% endif %}
