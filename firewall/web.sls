# XXX Insert is broken in 2014.1.0 due to https://github.com/saltstack/salt/issues/10988
# This is fixed in 2014.1.1, awaiting the release of that.
http iptables:
   #iptables.insert:
   iptables.append:
      - position: 3
      - table: filter
      - chain: INPUT
      - jump: ACCEPT
      - match: state
      - connstate: NEW
      - dport: 80
      - proto: tcp
      - save: True

https iptables:
   #iptables.insert:
   iptables.append:
      - position: 3
      - table: filter
      - chain: INPUT
      - jump: ACCEPT
      - match: state
      - connstate: NEW
      - dport: 443
      - proto: tcp
      - save: True
