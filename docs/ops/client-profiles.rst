Client Profiles
===============

Each client that needs to connect should have their own client key. Clients should generate their own key and send a certificate signing request to the operator for them to verify and then return a signed certificate.

Key Generation
--------------

To create a key, the client should generate a key and CSR...

::

    # a temporary directory to work in
    $ mkdir tmp-myovpn
    $ cd tmp-myovpn

    # a unique name to represent this client key
    $ TMP_CN=$( hostname -s )-$( date +%Y%m%da )

    # create the key and csr
    $ openssl req -new -nodes -days 3650 -newkey rsa:2048 \
      -subj "/C=$EASYRSA_REQ_COUNTRY/ST=$EASYRSA_REQ_PROVINCE/L=$EASYRSA_REQ_CITY/O=$EASYRSA_REQ_ORG/OU=$EASYRSA_REQ_OU/CN=$TMP_CN/emailAddress=$( git config user.email )" \
      -out "../pki/reqs/$TMP_CN.req" \
      -keyout openvpn.key

The operator can then :ref:`sign the request <ops-local-pki-signing>`.

Client Configuration
--------------------

Generally, OpenVPN clients will need to use a ``*.ovpn`` profile file to establish a connection to the OpenVPN server. The profile file contains connection parameters and authentication information.

When generating a certificate, you may also want to provide the user with a base profile file and allow the user to append their key. Here's an example script which can be included alongside your `pki` directory...

.. literalinclude:: ovpn-profile.sh
   :language: bash

Once the user appends their private key to the profile, they can use file with their OpenVPN client...

::

    $ openvpn --config client.ovpn
