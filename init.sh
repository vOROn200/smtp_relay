#!/bin/sh

# Set timezone
if [ ! -z "${SYSTEM_TIMEZONE}" ]; then
    echo "configuring system timezone"
    echo "${SYSTEM_TIMEZONE}" > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
fi

# Set mynetworks for postfix relay
if [ ! -z "${MYNETWORKS}" ]; then
    echo "setting mynetworks = ${MYNETWORKS}"
    postconf -e mynetworks="${MYNETWORKS}"
fi

# General the email/password hash and remove evidence.
if [ ! -z "${EMAIL}" ] && [ ! -z "${EMAILPASS}" ]; then
    echo "[127.0.0.1]:2525    ${EMAIL}:${EMAILPASS}" > /etc/postfix/sasl_passwd
	echo "${EMAIL}    [127.0.0.1]:2525" > /etc/postfix/sender_relay
    postmap /etc/postfix/sasl_passwd
	postmap /etc/postfix/sender_relay
    rm /etc/postfix/sasl_passwd
    echo "postfix EMAIL/EMAILPASS combo is setup."
else
    echo "EMAIL or EMAILPASS not set!"
fi
unset EMAIL
unset EMAILPASS
