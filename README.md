# lamp-install-wp


It will install a LAMP environment suitable to the WordPress requirements. Configure the virtual hosts in Apache2 and create an exclusive database for wordpress, as well as the root of the website.

This particular Role will leave the site operational without human intervention, as it uses wp-cli to complete the WordPress installation automatically.


## These other apache variables

You can defined that variables under the **vars/** directory of the same role. But i recommend to define this variables under the Ansible directories **host_vars**.

```
http_host: "site-name"
http_fqdn: "www.site-name.example.com"
http_conf: "site-name.conf"
http_port: "80"
```

We define the user with which the web-apps/web-site will be executed.

```
app_user: www-data
```

The following variables are used by the apache.conf.j2 template.

```
 http_host: "site-name"
 http_conf: "site-name.conf"
 server_admin: ""
```

## The variables of the db is define under the Ansible directories **host_vars**

I recomment to use a file with the name **host_var/server-hostname/vars/10_LAMP_WP.yml**.

```
 wp_mysql_db: "databasename"
 wp_mysql_user: "username"
```


## The variables of the wp-cli is define under the Ansible directories "host_vars"**

We are goin to install wp-cli to mange WP in a CLI environment, we need to define an administrator to define the script.
I recomment to use a file with the name **host_var/server-hostname/vars/10_LAMP_WP.yml**.

```
#Administrador WP con wp-cli
adminwpcli: "userAdminName"
wp_admin_user: "userAdministrator"
wp_admin_password: "{{ vault_wp_admin_password }}"
wp_admin_email: "email-example@example.io"
```

All these variables are necessary for the role to finish configuring the site and leaving it in production.

## Set root password, encrypted with Vault
define vault file, **host_var/server-hostname/vault/main.yml**

```
mariadb_root_password: "{{ vault_mariadb_root_password }}"
```

## Define database password tu use wordpress, encrypted with vault

```
wp_mysql_password: "{{ vault_wp_mysql_password }}"
``` 

## Note:
 
 As they are defined under the default directory, they are low precedence variables, they can be overridden by defining them in host_vars and encrypted with the vault, recommended!!


## Example Playbook
----------------

Including an example of how to use your role. In the section where it calls the role, we see that it just names it and we don't give it the full path. This is because the path where the roles are located is defined in the ansible.cfg file.

It is possible to use other tags to call specific tasks of the role, within each tasks/ there are defined tags. It is possible to execute each one individually by changing the tags of the playbook


```
---
# playbook, para configurar un entorno LAMP en un host  una vez creado
#

- name: Configuración de un entorno LAMP y Instalación de Wordpress
  hosts: fqdn-host
  remote_user: remote-user
  become: yes

  roles:
    - inst-systemconfig
    - inst-apache
    - inst-php
    - inst-mysql
    - inst-wp-cli
    - inst-lamp
    

  #Es 
  tags: inst-lamp
```

## Note:

We will define this version as 1.0 to finalize the first version of all the code. In future changes let's think about following the flow of Debian/Ubuntu systems that don't define a root password.

On the other hand we thought of uncommenting the curl extension (extension=curl) from the /etc/php/7.4/apache2/php.ini file, or adding it to the end.