FROM ubuntu:trusty
MAINTAINER Artem Yushkov "artem.yushkov@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get update && apt-get -q -y install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules stunnel4 syslog-ng syslog-ng-core supervisor \
# main.cf
&& postconf -e smtpd_banner="\$myhostname ESMTP" \
&& postconf -e relayhost=127.0.0.1:25025 \
&& postconf -e smtp_sasl_auth_enable=yes \
&& postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd \
&& postconf -e smtp_sasl_security_options=noanonymous \
&& postconf -e smtp_sasl_type=cyrus \
&& postconf -e smtp_sasl_mechanism_filter=login \
&& postconf -e smtp_sender_dependent_authentication=yes \
&& postconf -e sender_dependent_relayhost_maps=hash:/etc/postfix/sender_relay \
# system() can't be used since Docker doesn't allow access to /proc/kmsg.
# https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
&&  sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf \
#>> Cleanup
&& rm -rf /var/lib/apt/lists/* /tmp/* \
&& apt-get autoremove -y \
&& apt-get autoclean \
&& mkdir /var/log/mail \
&&  sed -ri 's/\/var\/log\/mail/\/var\/log\/mail\/mail/g' /etc/syslog-ng/syslog-ng.conf


ADD supervisord.conf /etc/supervisor/
ADD init.sh /opt/init.sh
ADD yandex.conf /etc/stunnel/yandex.conf
RUN chmod a+x /opt/init.sh

EXPOSE 25

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]