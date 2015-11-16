# docker-postfix-yandex-relay
A docker image that uses postfix as a relay through yandex. Useful to link to other images.

## configure
```bash
SYSTEM_TIMEZONE = UTC or America/New_York
MYNETWORKS = "10.0.0.0/8 192.168.0.0/16 172.0.0.0/8"
EMAIL = yandex mail or ppd domain
EMAILPASS = password (is turned into a hash and this env variable is removed at boot)
```

## example

```bash
docker run -i -t --rm --name smtp_relay -p 9025:25 \ 
       -e SYSTEM_TIMEZONE="Europe/Kiev" \ 
	   -e MYNETWORKS="10.0.0.0/8 192.168.0.0/16 172.0.0.0/8" \ 
	   -e EMAIL="mymail@yandex.ru" \ 
	   -e EMAILPASS="mypassword" 
```

