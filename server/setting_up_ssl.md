# Setting up SSL on Windows

The steps to set up SSL on Windows are as follows.

First, create a certificate using powershell, and copy the thumbprint from the output

```powershell
New-SelfSignedCertificate -DnsName eventstore.org, localhost -CertStoreLocation cert:\CurrentUser\My
```

To trust the new certificate, the certificate you have to import the certificat into the Trusted Root Certification Authorities:

<!-- TODO: Images maybe? -->

1.  Press _WindowsKey + R_, and enter 'certmgr.msc'.  
2.  Navigate to _Certificates -> Current User -> Personal -> Certificates_.  
3.  Locate the certificate 'eventstore.org'.
4.  _Right click_ on the certificate and click on _All Tasks -> Export_. Follow the prompts.
5.  Navigate to _Certificates -> Current User -> Trusted Root Certification Authorities -> Certificates_.  
6.  _Right click_ on the Certificates folder menu item and click _All Tasks -> Import_. Follow the prompts.

Start Event Store with the following configuration:

<!-- TODO: Again, what does this mean? -->

```powershell
CertificateStoreLocation: CurrentUser
CertificateStoreName: My
CertificateThumbPrint: {Insert Thumb Print from Step 1}
CertificateSubjectName: CN=eventstore.org
ExtSecureTcpPort: 1115
```

Connect to Event Store using the Event Store .NET Client.

```csharp
var settings = ConnectionSettings.Create().UseSslConnection("eventstore.org", true);

using (var conn = EventStoreConnection.Create(settings, new IPEndPoint(IPAddress.Loopback, 1115)))
{
	conn.ConnectAsync();
}
```
