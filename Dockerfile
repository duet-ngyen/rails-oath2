
FROM ubuntu:16.04

ENV RUBY_MAJOR="2.3.3" \
    RUBY_VERSION="2.3.3" \
    DB_PACKAGES="libpq-dev" \
    RUBY_PACKAGES="ruby2.3.3 ruby2.3.3-dev"
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      curl dpkg-dev perl-modules liberror-perl git git-core libc6-dev \
      libncurses5 libtinfo-dev ncurses-bin libc-dev libkrb5-dev comerr-dev\
      libreadline6 zlib1g libc6-dev libffi-dev \
      libgdbm-dev \
      libncurses-dev \
      libreadline6-dev \
      libssl-dev \
      libyaml-dev \
      zlib1g-dev \
      libgmp-dev \
      libpq-dev vim imagemagick build-essential \
  && rm -rf /var/lib/apt/lists/*

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && curl --silent --location https://deb.nodesource.com/setup_0.12 | bash - && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
RUN apt-get update && apt-get install -y mysql-client postgresql-client libsqlite3-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*




RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc



# install ruby-build

ENV RUBY_VERSION 2.3.3
RUN rbenv install $RUBY_VERSION && rbenv local $RUBY_VERSION
RUN /bin/bash -l -c "gem install --no-ri --no-rdoc bundler"
RUN rbenv rehash
RUN /bin/bash -l -c "gem install rails -v '>= 5.0.0' --no-ri --no-rdoc" && \
    rbenv rehash

ENV PATH /root/.rbenv/bin:/root/.rbenv/shims:$PATH
RUN echo "export PATH=$PATH" >> /root/.bashrc

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"


RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN rbenv local $RUBY_VERSION
#RUN /bin/bash -l -c "bundle install"
#ADD . /myapp
CMD ["/bin/bash"]