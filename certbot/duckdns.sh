#!/bin/bash

# Install curl
apt-get install curl -y

# Sets Certbot's TXT records on Duck DNS domains

if [[ ! $CERTBOT_DOMAIN ]]; then
	echo "Missing domain!"
	exit 1
fi

# Strip duckdns domain
CERTBOT_DOMAIN=${CERTBOT_DOMAIN%%.duckdns.org}
# Then strip any sub-subdomains
CERTBOT_DOMAIN=${CERTBOT_DOMAIN##*.}

if [[ $1 == "cleanup" ]]; then
	curl -k "https://www.duckdns.org/update?domains=${CERTBOT_DOMAIN}&token=${DUCKDNS_TOKEN}&txt=whatever&clear=true"
elif [[ $CERTBOT_VALIDATION ]]; then
	curl -k "https://www.duckdns.org/update?domains=${CERTBOT_DOMAIN}&token=${DUCKDNS_TOKEN}&txt=${CERTBOT_VALIDATION}"
else
	echo "Missing certbot validation text!"
	exit 1
fi

# Wait a while for the DNS to propagate
sleep 5s

