codeready linux builder repo:
  cmd.run:
    - name: subscription-manager repos --enable "codeready-builder-for-rhel-8-{{ grains['osarch'] }}-rpms"
