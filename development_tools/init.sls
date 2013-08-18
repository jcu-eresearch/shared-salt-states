Development Tools:
# pkg.group_install is not yet avaiable as a state.
# This may be ready in salt 0.17
# For now, just use cmd.run
  cmd.run:
    - name: yum groupinstall -y "Development Tools"
