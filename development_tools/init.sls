# pkg.group_install is not yet available as a state.
# See https://github.com/saltstack/salt/issues/5504
{% if grains['os_family'] == 'RedHat' %}
Development Tools:
  module.run:
    - name: pkg.group_install
  {% if grains['osmajorrelease']|int >= 7 %}
    - m_name: Development Tools
  {% elif grains['osmajorrelease'] == '6' %}
    - m_name: Development tools
  {% endif %}
{% endif %}
