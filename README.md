# Stanford NER service

A single script to download, setup and install Stanford NER as a service.


## Install

```bash
sudo ./ner-install.sh
```

The `STANFORD_NER_PORT` environment variable should be set before execution.

You will probably need to run with `sudo` permissions to edit system services.


## Run service

```bash
systemctl start ner.service
```

Stop with:
```bash
systemctl stop ner.service
```
