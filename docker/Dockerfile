FROM centos:7
RUN yum install -y git-core zlib zlib-devel gcc-c++ \
                   patch readline readline-devel libyaml-devel libffi-devel \
                   openssl-devel make bzip2 autoconf automake libtool bison \
                   sqlite-devel libxslt-devel libxml2-devel postgresql-libs \
                   postgresql-devel curl which rvm git java-1.8.0-openjdk gnupg2 

RUN useradd -ms /bin/bash mmt
RUN mkdir /scripts
ADD scripts/install_ruby.sh /scripts
RUN bash -l /scripts/install_ruby.sh
RUN usermod -a -G rvm mmt

USER mmt
WORKDIR /home/mmt

RUN mkdir ~/scripts
ADD scripts/install_mmt.sh /home/mmt/scripts/
ADD scripts/install_db.sh /home/mmt/scripts/
ADD scripts/entry_point.sh /
RUN bash -l /home/mmt/scripts/install_mmt.sh

ADD config/application.yml /home/mmt/mmt/config
RUN mkdir /home/mmt/mmt/cmr
ADD libs/cmr-dev-system-0.1.0-SNAPSHOT-standalone.jar /home/mmt/mmt/cmr
RUN bash -l /home/mmt/scripts/install_db.sh

CMD ["bash", "-l", "/entry_point.sh"]

