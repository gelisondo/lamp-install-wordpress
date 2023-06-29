#!/bin/bash

chown -R www-data:www-data /var/www/
find /var/www/ -type f -exec chmod 664 {} \;
find /var/www/ -type d -exec chmod 775 {} \;
