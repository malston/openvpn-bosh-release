#!/bin/sh

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat <<EOF
client
dev tun
proto tcp
remote $OPENVPN_HOST $OPENVPN_PORT
comp-lzo
resolv-retry infinite
nobind
persist-key
persist-tun
mute-replay-warnings
remote-cert-tls server
verb 3
mute 20
tls-client
<ca>
$( cat $DIR/pki/ca.crt )
</ca>
EOF

if [ -n "${CN:-}" ] && [ -e "$DIR/pki/issued/$CN.crt" ] ; then
  # if we have a certificate, append it
  cat <<EOF
<cert>
$( cat $DIR/pki/issued/$CN.crt )
</cert>
EOF
fi

if [ -n "${CN:-}" ] && [ -e "$DIR/pki/private/$CN.key" ] ; then
  # if we have a private key, append it
  cat <<EOF
<key>
$( cat $DIR/pki/private/$CN.key )
</key>
EOF
fi
