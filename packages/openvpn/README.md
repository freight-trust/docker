# Docker OpenVPN + 2FA

> Some Modifications have been made to the current Docker OpenVPN implementation including using a newer library for the 2FA 

\* Add a new service in docker-compose.yml

```yaml
version: '2'
services:
  openvpn:
    cap_add:
     \- NET_ADMIN
    image: kylemanna/openvpn
    container_name: openvpn
    ports:
     \- "1194:1194/udp"
    restart: always
    volumes:
     \- ./openvpn-data/conf:/etc/openvpn
```


\* Initialize the configuration files and certificates

```bash
docker-compose run --rm openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
docker-compose run --rm openvpn ovpn_initpki
```

\* Fix ownership (depending on how to handle your backups, this may not be needed)

```bash
sudo chown -R $(whoami): ./openvpn-data
```

\* Start OpenVPN server process

```bash
docker-compose up -d openvpn
```

\* You can access the container logs with

```bash
docker-compose logs -f
```

\* Generate a client certificate

```bash
export CLIENTNAME="your\_client\_name"
\# with a passphrase (recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
\# without a passphrase (not recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
```

\* Retrieve the client configuration with embedded certificates

```bash
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
```

\* Revoke a client certificate

```bash
\# Keep the corresponding crt, key and req files.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME
\# Remove the corresponding crt, key and req files.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME remove
```

\## Debugging Tips

\* Create an environment variable with the name DEBUG and value of 1 to enable debug output (using "docker -e").

```bash
docker-compose run -e DEBUG=1 -p 1194:1194/udp openvpn
```

## 2FA Usage

In order to enable two factor authentication the following steps are required.

\* Choose a more secure \[cipher\](https://community.openvpn.net/openvpn/wiki/SWEET32) to use because since \[OpenVPN 2.3.13\](https://community.openvpn.net/openvpn/wiki/ChangesInOpenvpn23#OpenVPN2.3.13) the default openvpn cipher BF-CBC will cause a renegotiated connection every 64 MB of data

\* Generate server configuration with `-2` and `-C $CIPHER` options

        docker run -v $OVPN\_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn\_genconfig -u udp://vpn.example.com -2 -C $CIPHER

\* Generate your client certificate (possibly without a password since you're using OTP)

        docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full <user> nopass

\* Generate authentication configuration for your client. -t is needed to show QR code, -i is optional for interactive usage

        docker run -v $OVPN\_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn\_otp_user <user>

The last step will generate OTP configuration for the provided user with the following options

```
google-authenticator --time-based --disallow-reuse --force --rate-limit=3 --rate-time=30 --window-size=3 \
    -l "${1}@${OVPN\_CN}" -s /etc/openvpn/otp/${1}.google\_authenticator
```

It will also show a shell QR code in terminal you can scan with the Google Authenticator application. It also provides
a link to a google chart url that will display a QR code for the authentication.

**Do not share QR code (or generated url) with anyone but final user, that is your second factor for authentication
  that is used to generate OTP codes**

Here's an example QR code generated for an hypotetical user@example.com user.

!\[Example QR Code\](https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/user@example.com%3Fsecret%3DKEYZ66YEXMXDHPH5)

Generate client configuration for `<user>` and import it in OpenVPN client. On connection it will prompt for user and password.
 Enter your username and a 6 digit code generated by Authenticator app and you're logged in.

### TL;DR

Under the hood this configuration will setup an \`openvpn\` PAM service configuration (`/etc/pam.d/openvpn`)
that relies on the awesome \[Google Authenticator PAM module\](https://github.com/google/google-authenticator).
In this configuration the \`auth\` part of PAM flow is managed by OTP codes and the \`account\` part is not enforced
 because you're likely dealing with virtual users and you do not want to create a system account for every VPN user.

\`ovpn\_otp\_user\` script will store OTP credentials under `/etc/openvpn/otp/<user>.google_authentication`. In this
 way when you take a backup OTP users are included as well.

Finally it will enable the openvpn plugin \`openvpn-plugin-auth-pam.so\` in server configuration and append the
\`auth-user-pass\` directive in client configuration.

### Debug

If something is not working you can verify your PAM setup with these commands

```
\# Start a shell in container
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn bash
\# Then in container you have pamtester utility already installed
which pamtester
\# To check authentication use this command that will prompt for a valid code from Authenticator APP
pamtester -v openvpn <user> authenticate
```

In the last command `<user>` should be replaced by the exact string you used in the ovpn\_otp\_user command.

If you configured everything correctly you should get authenticated by entering a OTP code from the app.
