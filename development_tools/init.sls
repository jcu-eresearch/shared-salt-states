# pkg.group_install is not yet available as a state.
# See https://github.com/saltstack/salt/pull/3524
Development Tools:
  cmd.run:
    - name: yum groupinstall -y "Development Tools"

#  module.run:
#    - name: salt.modules.yumpkg.group_install
#    - groups: 
#        - Development Tools
