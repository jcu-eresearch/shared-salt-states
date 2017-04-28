#Warning: use this at your own risk.
#An edge or corner case here could erase your data!
#You should consider running this state on its own to verify execution:
#
#salt-call --local state.sls 'jcu.mount.volume_storage'

include:
  - jcu.mount

{% for device, settings in pillar['volumes'].items() %}

#Return code from ``read`` is 0 (True) if something, 1 (False) if nothing
#This means the ``unless`` conditions will be true on finding a device,
#and thus halt execution of filesystem manipulation.
{% set check_exists = 'blkid | grep ' + device + ' | read' %}

# Test device existence
{{ device }}:
  file.exists

# Create partition table
{{ device }} partition table:
  cmd.run:
    - name: parted -s {{ device }} mklabel msdos
    - require:
      - pkg: parted
      - file: {{ device }}
    - unless: {{ check_exists }}

# Create partition
{{ device }} primary partition:
  cmd.run:
    - name: parted -s {{ device }} mkpart primary ext4 2048s 100%
    - require:
      - pkg: parted
      - cmd: {{ device }} partition table
    - unless: {{ check_exists }}

# Test parition existence
{{ device }}1:
  file.exists:
    - require:
      - cmd: {{ device }} primary partition

# Format partition
{{ device }} partition formatting:
  cmd.run:
    - name: mkfs.{{ settings['fstype'] }} {{ device }}1
    - require:
      - file: {{ device }}1
    - unless: {{ check_exists }}

# Mount on machine
{{ device }} mount:
  mount.mounted:
    - name: {{ settings['mount'] }}
    - device: {{ device }}1
    - fstype: {{ settings['fstype'] }}
    - mkmnt: {{ settings['mkmnt'] }}
    - opts: {{ settings.get('opts', 'defaults,noatime,nodiratime,errors=remount-ro') }}
    - require:
      - file: {{ device }}1

{% endfor %}
