# lamp-install-wp

It will install a LAMP environment suitable to the WordPress requirements. Configure the virtual hosts in Apache2 and create an exclusive database for wordpress, as well as the root of the website.

This particular Role will leave the site operational without human intervention, as it uses wp-cli to complete the WordPress installation automatically.

Lists of differences in role versions:

- v1.0    In this version Install WP without human intervention post install the CMS.
- v1.1.0  In this version we will not set the password for root user. By default the new systems are configured like this.
- v1.2.0  In this version you will be able to define several sites that you need to install.

## Listas de variables:

In version v1.2.0 we use an Ansible dictionary to define the variables for the different sites. Following the same logic we can add the variable lists with the key "siteN".

In the following example we can see that the **Apache** and **MySql/MariaDB** variables are defined, independently for each site.

Recommend to define this variables under the Ansible directories **host_vars**.

```
#example
sites_config:
  site1:
    http_host: siteone
    http_fqdn: siteone.testdomain.com
    http_conf: siteone.conf
    wp_mysql_db: DataBSecuel992X
    wp_mysql_user: Scd-ksdSKDKl
    wp_mysql_password: "{{ vault_wp_mysql_password_site1 }}"
    
  site2:
    http_host: sitetwo
    http_fqdn: sitetwo.testdomain.com
    http_conf: sitetwo.conf
    wp_mysql_db: DataBSecuel992X2
    wp_mysql_user: Scd-ksdSKDKl2
    wp_mysql_password: "{{ vault_wp_mysql_password_site2 }}"

  site3:
    http_host: sitethree
    http_fqdn: sitethree.testdomain.com
    http_conf: sitethree.conf
    wp_mysql_db: DataBSecuel992X23
    wp_mysql_user: Scd-ksdSKDKl23
    wp_mysql_password: "{{ vault_wp_mysql_password_site3 }}"
```

## Define database password tu use wordpress, encrypted with vault

We recommend encrypting all passwords in the vault. so that they are not exposed in the repository.

```
vault_wp_mysql_password_site1: 'dkK999kLVKlsk3902948ws'
vault_wp_mysql_password_site2: 'SKdlxkkExamplek9928lsk'
vault_wp_mysql_password_site3: 'SK33kkExsamplek3333lsk'
``` 


## These global Apache variables

You can defined that variables under the **vars/** directory of the same role. But i recommend to define this variables under the Ansible directories **host_vars**.

```
http_port: "80"
```

We define the user with which the web-apps/web-site will be executed.

```
app_user: www-data
```

The following variables are used by the apache.conf.j2 template.

Estraction to the dictionary **sites_config**.
```
 item.value.http_host: "site-name"
 item.value.http_conf: "site-name.conf"
 
```

Define in the vars of the rols.

```
server_admin: ""
```

## The variables of the wp-cli is define under the Ansible directories "host_vars"**

We are goin to install wp-cli to mange WP in a CLI environment, we need to define an administrator to define the script.
I recomment to use a file with the name **host_var/server-hostname/vars/10_LAMP_WP.yml**.

```
#Admin WP with wp-cli
adminwpcli: "userAdminName"
wp_admin_user: "userAdministrator"
wp_admin_password: "{{ vault_wp_admin_password }}"
wp_admin_email: "email-example@example.io"
```

All these variables are necessary for the role to finish configuring the site and leaving it in production.

## Not set the root password:

  After version 1.1.0 we will not set the root password, generally new systems do not set these passwords. For 
that reason we decided to follow the design flow of the operating system.


## Note:
 
 As they are defined under the default directory, they are low precedence variables, they can be overridden by defining them in host_vars and encrypted with the vault, recommended!!


# Example Playbook
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
  gather_facts: yes

  tags:
    - lamp-install-wp
```
