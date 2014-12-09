---
title: "Setting up SSL in Windows"
section: "HTTP API"
version: 3.0.1
---

Setting up SSL in windows is the same as setting up any httplistener in windows for SSL. Numerous examples of this can be found online. We have copy/pasted one that we tested to work out.

From [Damir Dobric] (http://developers.de/blogs/damir_dobric/archive/2006/08/01/897.aspx)

## Creating and installing of the server certificate for SSL

Before the listener can be configured, first the required server certificate has to be created and properly installed:

Following line shows how to create the test X509 certificate which will be used for SSL communication at the machine 192.168.100.186.

```
makecert.exe -sr LocalMachine -ss My -n CN=192.168.100.186 -sky exchange -sk -pe
```
 
<span class="note">
This machine (with IP 192.168.100.186) will host the WCF service, which should support the HTTPS. Please also note that the test certificate created with the makecert tool is signed by virtual trust center ‘Root Agency’ (self signed for testing purposes only).
</span>

After this command is executed, the new certificate with the private key is created and stored in the LocalMachine Personal store. To see it, use the MMC-certificate snap-in.

After this step the HttpListener could be configured. However in the test scenario there will be a client which will probably run at the same machine. Because of this execute following command to install the newly created server certificate in the user’s “Trusted People” store.

```
certmgr.exe -add -r LocalMachine -s My -c -n 192.168.100.186 -r CurrentUser -s
```

This command reads the server’s certificate (created in the previous step with makecert.exe) with the friendly name `CN=192.168.100.186` from the LocalMachine “Personal” store and make one copy in the CurrentUser “Trusted People” store.

This establishes the client’s trust to the certificate.

## Configuring HttpListener

First you have to do is to download the required tool HttpCfg.Exe, which is a part of Windows XP SP2 Support Tools.

Here are some examples:

Configure HttpListener to provide SSL at all IP-addresses, but on the port 999.

```
Httpcfg.exe set ssl -i 0.0.0.0:999 -h e81bada10ffddf6fce0628ab491eecf8d2a4d070 -Personal
```

The value specified in the argument `–h` is the certificate's thumbprint (hash), which can be copied from any certificate viewer. I used MMC cetificates snap-in to browse for certificate. Under details tab, select Thumbprint and copy the binary-value. Finally, remove all blanks. 

Following command is useful to show what certificates are already configured:

```
Httpcfg.exe query ssl
```

After executing, following result could appear: 

```
 IP                      : 0.0.0.0:999
 Hash                    : 2b7f1ebe2ae632c5d7328a8f849ffde0b4 3c07c
 Guid                    : {00000000-0000-0000-0000-000000000000}
 CertStoreName           : MY
 CertCheckMode           : 0
 RevocationFreshnessTime : 0
 UrlRetrievalTimeout     : 0
 SslCtlIdentifier        : (null)
 SslCtlStoreName         : (null)
 Flags                   : 0
```

Sometimes it is useful to delete the previously configured certificate, before the new one is installed:

```
Httpcfg.exe delete ssl -i 0.0.0.0:999
```