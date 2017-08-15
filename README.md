# Stanford NER service

A single script to download, setup and install Stanford NER as a service.


## Install

The `STANFORD_NER_PORT` environment variable should be set before execution.

```bash
sudo STANFORD_NER_PORT=1234 ./ner-install.sh
```

You will probably need to run with `sudo` permissions to edit system services.


## Requirements

This repo was written to target an AWS Amazon Linu EC2 instance (Centos 6).
Compatibility fixes for other platforms are welcome.


## The `stanford-nerd` daemon

The installed daemon is a System V `init.d` script that should be compatible with most linux distros.

Usage:
```bash
/etc/init.d/stanford-nerd start|stop|restart|force-reload|status
```
