---
outputFileName: index.html
---

# Setting up SSL on Linux

> [!NOTE]
> This guide uses the latest Ubuntu LTS (18.04)

First, create a private key and self-signed certificate request (This is only for testing purposes)

```bash
openssl req \
  -x509 -sha256 -nodes -days 365 -subj "/CN=eventstore.org" \
  -newkey rsa:2048 -keyout eventstore.pem -out eventstore.csr
```

Export a p12 file from the certificate request. You use this when starting Event Store:

```bash
openssl pkcs12 -export -inkey eventstore.pem -in eventstore.csr -out eventstore.p12
```

You need to add the certificate to Ubuntu's trusted certificates. Copy the cert to the _ca-certificates_ folder and update the certificates:

```bash
sudo cp eventstore.csr /usr/local/share/ca-certificates/eventstore.crt

sudo update-ca-certificates
```

The mono framework has its own separate certificate store which you need to sync with the changes you made to Ubuntu's certificates.

You first need to install `mono-devel`:

```bash
sudo apt-get install mono-devel
```

This process installs `cert-sync`, which you use to update mono's certificate store with the new certificate:

```bash
sudo cert-sync eventstore.csr
```

Start Event Store with the following configuration in [a configuration file](~/server/command-line-arguments.md#yaml-files):

```yaml
CertificateFile: eventstore.p12
ExtSecureTcpPort: 1115
```

Connect to Event Store:

## [.NET API](#tab/tabid-8)

```csharp
var settings = ConnectionSettings.Create().UseSslConnection("eventstore.org", true);

using (var conn = EventStoreConnection.Create(settings, new IPEndPoint(IPAddress.Loopback, 1115)))
{
    conn.ConnectAsync().Wait();
}
```

## [HTTP API](#tab/tabid-9)

```bash
curl -vk --cert <PATH_TO_CERT> --key <PATH_TO_KEY> -i -d "@event.json" "http://127.0.0.1:2113/streams/newstream" -H "Content-Type:application/vnd.eventstore.events+json"
```

* * *