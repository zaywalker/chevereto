#!/bin/bash
set -e

# Create missing directory if we don't have and give permission
[[ ! -d /var/www/html/ ]] && mkdir -p /var/www/html/
chown www-data:www-data /var/www/html

# Get installer.php if there is no index.php (it means already be installed chevereto)
[[ ! -f /var/www/html/index.php ]] && curl -o /var/www/html/installer.php https://chevereto.com/download/file/installer && chown www-data:www-data /var/www/html/installer.php

# Run apache2 foreground
/usr/local/bin/apache2-foreground
