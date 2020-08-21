FROM centos:8
MAINTAINER "JCU eResearch Centre" <eresearch.nospam@jcu.edu.au>

# Bootstrap Salt
RUN dnf install -y https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm && \
  dnf clean expire-cache && \
  dnf install -y salt-master salt-minion

# git is needed to clone our project
RUN dnf install -y git

CMD git clone --recursive https://github.com/jcu-eresearch/shared-salt-states-standalone.git /app && \
  cd /app/.setup && \
  ./highstate.sh
