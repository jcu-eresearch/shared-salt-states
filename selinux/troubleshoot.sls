include:
  - jcu.selinux

setroubleshoot:
  pkg.installed

setroubleshoot-server:
  pkg.installed

restart auditd:
  cmd.wait:
    - name: service auditd restart
    - watch:
      - pkg: setroubleshoot
      - pkg: setroubleshoot-server
