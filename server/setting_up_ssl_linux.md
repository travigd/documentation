---
section: "Server"
version: "4.0.2"
---

# Setting up SSL on Ubuntu 16.04

The steps to set up SSL on Ubuntu 16.04 are as follows:

First, create a private key and self-signed certificate request (This is only for testing purposes)

```bash
openssl req \
  -x509 -sha256 -nodes -days 365 -subj "/CN=geteventstore.com" \
  -newkey rsa:2048 -keyout geteventstore.pem -out geteventstore.csr
```

Export a p12 file from the certificate request. You will use this when starting Event Store :

```bash
openssl pkcs12 -export -inkey geteventstore.pem -in geteventstore.csr -out geteventstore.p12
```

You need to add the certificate to Ubuntu's trusted certificates. Copy the cert to the _ca-certificates_ folder and update the certificates :

```bash
sudo cp geteventstore.csr /usr/local/share/ca-certificates/geteventstore.crt

sudo update-ca-certificates
```

The mono framework has its own separate certificate store which you need to sync with the changes you made to Ubuntu's certificates.

You will first need to install `mono-devel`:

```bash
sudo apt-get install mono-devel
```

This installs `cert-sync`, which you can use to update mono's certificate store with the new certificate :

```bash
sudo cert-sync geteventstore.csr
```

Start Event Store with the following configuration:

<!-- TODO: How? -->

```bash
CertificateFile: geteventstore.p12
ExtSecureTcpPort: 1115
```

Connect to Event Store using the Event Store .NET Client.

```csharp
var settings = ConnectionSettings.Create().UseSslConnection("geteventstore.com", true);

using (var conn = EventStoreConnection.Create(settings, new IPEndPoint(IPAddress.Loopback, 1115)))
{
    conn.ConnectAsync().Wait();
}
```
