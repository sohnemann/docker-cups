# CUPS Docker Image

## Architectures

- amd64
- arm32v7
- arm64v8

## Usage

### Start the container

```bash
docker run --name cups -d --restart always -p 631:631 -v $(pwd):/etc/cups cups:latest
```

### Configuration

Login in to CUPS web interface on port 631 (e.g. https://localhost:631) and configure CUPS to your needs.
Default credentials: admin / admin

To change the admin password set the environment variable _ADMIN_PASSWORD_ to your password.

```bash
docker run --name cups -d --restart always -p 631:631 -v $(pwd):/etc/cups -e ADMIN_PASSWORD=mySecretPassword cups:latest
```
