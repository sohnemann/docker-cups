# CUPS Docker Image

## Start the container

```bash
touch $(pwd)/printers.conf
docker run -d --restart always -v $(pwd)/printers.conf:/etc/cups/printers.conf -v $(pwd)/ppd:/etc/cups/ppd ydkn/cups:latest
```
