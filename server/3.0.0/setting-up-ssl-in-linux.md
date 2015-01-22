---
title: "Setting up SSL in Linux"
section: "Server"
version: 3.0.0
---

Setting up SSL in Linux is the same as setting up any mono httplistener in Linux for SSL. Numerous examples of this can be found online. We have copy/pasted one that we tested to work out. This methodology will likely work for other systems such as openbsd as well.

From [Joshua Perina](http://joshua.perina.com/geo/post/using-ssl-https-with-mono-httplistener).

## Create a key file:

```
$openssl genrsa -des3 -out yourdomain.pem 2048
```

## Optionally remove the password:

```
$openssl rsa -in yourdomain.pem -out yourdomain.pem.nopass
```

## Create the certificate signing request.  

Your certificate provider should have some instructions on what goes in each fields, but generally the domain name you want to secure goes in the Common Name field:

```
$openssl req -new -key yourdomain.pem.nopass -out yourdomain.csr
```

## Register the Certificate

Once you have the certificate file. For example yourdomain.crt you must register the certificate using the Mono utility `httpcfg`.  But first, you must convert your key file to the Microsoft Format .pvk or you will get this error: “error loading certificate or private key.”

[pvktool](http://www.drh-consultancy.demon.co.uk/pvk.html) can be downloaded to convert it.

Once you have it (either on Windows or Linux) run:

```
pvk -in yourdomain.pem.nopass -topvk -nocrypt -out yourdomain.pvk
```

## Register with httpcfg

```
$httpcfg -add -port 443 -pvk yourdomain.pvk -cert yourdomain.crt
```

To see the current registrations:

```
$httpcfg -list
```

Now run the Event Store on port 443.