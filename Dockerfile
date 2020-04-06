FROM alpine:latest

RUN addgroup rt && adduser -D -G rt rt

RUN apk --no-cache upgrade; apk add --no-cache \
    build-base \
    curl \
    emacs-nox \
    gd-dev \
    gnupg \
    graphviz \
    mini-sendmail \
    perl \
    perl-app-cpanminus \
    perl-dbd-mysql \
    perl-dev \
    perl-gd \
    perl-graphviz \
    perl-net-ssleay \
    perl-posix-strftime-compiler \
    ssmtp

RUN mkdir /usr/src

RUN curl -fLs https://download.bestpractical.com/pub/rt/devel/rt-5.0.0alpha1.tar.gz | tar -C /usr/src -xz

WORKDIR /usr/src/rt-5.0.0alpha1

RUN ./configure \
   --prefix=/opt/rt \
   --with-web-handler=standalone \
   --with-db-type=mysql \
   --with-db-rt-host=mysql \
   --with-web-user=rt \
   --with-web-group=rt

COPY files/root/.cpan/CPAN/MyConfig.pm /root/.cpan/CPAN/MyConfig.pm
RUN cpan -f GnuPG::Interface PerlIO::eol
RUN PERL5LIB=/opt/rt/lib cpanm \
    HTML::Element \
    Plack::Handler::Starman \
    RT::Extension::GroupSummary \
    RT::Extension::Memo \
    RT::Extension::QuickUpdate \
    RT::Extension::ResetPassword \
    RT::Extension::RightsInspector \
    RT::Extension::Slack \
    RT::Extension::Tags \
    RTx::Calendar

RUN yes n | make fixdeps

RUN make install

CMD /opt/rt/sbin/rt-server --server Starman --port 8000
