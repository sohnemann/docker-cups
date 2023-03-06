# CUPS Docker Image

## Architectures

- amd64
- arm32v7
- arm64v8

## Usage

### Start the container

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups ydkn/cups:latest
```

### Configuration

Login in to CUPS web interface on port 631 (e.g. https://localhost:631) and configure CUPS to your needs.
Default credentials: admin / admin

To change the admin password set the environment variable _ADMIN_PASSWORD_ to your password.

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups -e ADMIN_PASSWORD=mySecretPassword ydkn/cups:latest
```

If you wish to use PDF printing, you can map the output directory for cups-pdf. Substitute /tmp/pdf for the location your system you wish PDFs to save to.

```bash
docker run -d --restart always -p 631:631 -v $(pwd):/etc/cups -v /tmp/pdf:/var/spool/cups-pdf ydkn/cups:latest
```
