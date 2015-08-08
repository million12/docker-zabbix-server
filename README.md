### Zabbix-Server (CentOS-7 + Supervisor)

[![Circle CI](https://circleci.com/gh/million12/docker-zabbix-server/tree/master.svg?style=svg&circle-token=44c41e390572bda1350dc95f09273debd96131d7)](https://circleci.com/gh/million12/docker-zabbix-server/tree/master)  

[Docker Image](https://registry.hub.docker.com/u/million12/zabbix-server/) with Zabbix Server using CentOS-7 and Supervisor.
Image is using external datbase.  
This image is using offcial [zabbix-server-2.4](https://registry.hub.docker.com/u/zabbix/zabbix-server-2.4/) Docker Image as base image.

#### Installed Plugins
>    Email Notifications with authorisation  
>    Slack Notifications  
>    Nginx Status `/nginx_status`  
>    PHP-FPM Status `/fpm_status`

### Database deployment
To be able to connect to database we would need one to be running first. Easiest way to do that is to use another docker image. For this purpose we will use our [million12/mariadb](https://registry.hub.docker.com/u/million12/mariadb/) image as our database.

**For more information about million12/MariaDB see our [documentation.](https://github.com/million12/docker-mariadb) **

Example:  

	docker run \
		-d \
		--name zabbix-db \
		-p 3306:3306 \
		--env="MARIADB_USER=username" \
		--env="MARIADB_PASS=my_password" \
		million12/mariadb

***Remember to use the same credentials when deploying zabbix-server image.***


### Environmental Variable
In this Image you can use environmental variables to connect into external MySQL/MariaDB database.

`DB_USER` = database user  
`DB_PASS` = database password  
`DB_ADDRESS` = database address (either ip or domain-name).

Or you can use a linked container (MySQL/MariaDB) with a name `db` which exposes these environmental variables:

`MYSQL_ROOT_PASSWORD` or `MARIADB_USER`
`MYSQL_USER` or `MARIADB_PASS`

You can also set a custom timezone using the `TIME_ZONE` environmental variable:

`TIME_ZONE` = Custom timezone (e.g: America/Santiago; it takes a default of UTC)

### Zabbix-Server  Deployment
Now when we have our database running we can deploy zabbix-server image with appropriate environmental variables set.

Example:  

	docker run \
		-d \
		--name zabbix \
		-p 80:80 \
		-p 10051:10051 \
		--env="DB_ADDRESS=database_ip" \
		--env="DB_USER=username" \
		--env="DB_PASS=my_password" \
		million12/zabbix-server
With email settings and Slack integration and custom timezone:  

	docker run \
		-d \
		--name zabbix \
		-p 80:80 \
		-p 10051:10051 \
		--env="DB_ADDRESS=database_ip" \
		--env="DB_USER=username" \
		--env="DB_PASS=my_password" \
		--env="ZABBIX_ADMIN_EMAIL=default@domain.com" \
		--env="ZABBIX_SMTP_SERVER=default.smtp.server.com" \
		--env="ZABBIX_SMTP_USER=default.smtp.username" \
		--env="ZABBIX_SMTP_PASS=default.smtp.password" \
		--env="SLACK_WEBHOOK=https://hooks.slack.com/services/QQ3PTH/B67THC0D3/ABCDGabcDEF124" \
		--env="TIME_ZONE=America/Santiago" \
		million12/zabbix-server

With MySQL/MariaDB linked container:

~~~
docker run \
	-d \
	--name zabbix \
	-p 80:80 \
	-p 10051:10051 \
	--link some-mariadb:db \
	million12/zabbix-server
~~~

### Access Zabbix-Server web interface
To log in into zabbix-server for the first time use credentials `Admin:zabbix`.  

Access web interface under [http://docker_host.ip]()  

Follow the on screen instructions.

### Zabbix Push Notifications
Zabbix notification script is located in `/usr/local/share/zabbix/alertscripts`  
Please follow [Zabbkit manual](https://www.zabbix.com/forum/showthread.php?t=41967) to configure notifications.

### Email Notifications (Server settings)
Using environmental variables on `docker run` you can edit default email server settings. Valuse would be added on into `/usr/local/share/zabbix/alertscripts/zabbix_sendmail.sh`.  
Environmental variables are:  
`ZABBIX_ADMIN_EMAIL=default@domain.com`  
`ZABBIX_SMTP_SERVER=default.smtp.server.com`  
`ZABBIX_SMTP_USER=default.smtp.username`  
`ZABBIX_SMTP_PASS=default.smtp.password`  

Configuration:
Go into `Administration/Media types` and add new type using `script` as Type. Script name should be `zabbix_sendmail.sh`  

![Media type](https://raw.githubusercontent.com/million12/docker-zabbix-server/master/images/media-type.jpg)  

Next go to `Configuration/Actions` and create new action. Select recovery message.

![Actions1](https://raw.githubusercontent.com/million12/docker-zabbix-server/master/images/actions1.jpg)  

Next select tab `Operations` and click New to add new action. In `Send to User groups` add Zabbix Adminstrator or any user group you like.  In `Send only to` select Name of your previously created `Media type` name.  

![Actions2](https://raw.githubusercontent.com/million12/docker-zabbix-server/master/images/actions2.jpg)  

Next go to `Administration/Users` and select your user. Go to Media tab and add new Media. In `Type` select your `Media type` you have created in first step. Add your email addess and enjoy receiving emails.  

![User-Media](https://raw.githubusercontent.com/million12/docker-zabbix-server/master/images/user-media.jpg)

### Slack Integration
This docker image comes with Slack integrations script. You need to provide your `WebHook` generated in yo your Slack account. it should look like `https://hooks.slack.com/services/QQ3PTH/B67THC0D3/ABCDGabcDEF124`

Note: this Slack Integration script is based on one originally developed by [ericoc/zabbix-slack-alertscript](https://github.com/ericoc/zabbix-slack-alertscript).
For deatiled installation please see [ericoc instructions](https://github.com/ericoc/zabbix-slack-alertscript).

### Nginx Status Template
Nginx stats script is located in `/usr/local/share/zabbix/externalscripts/`.  
It's latest version of [vicendominguez/nginx-zabbix-template](https://github.com/vicendominguez/nginx-zabbix-template) official Zabbix communty repo.  
Gathering data is done by `getNginxInfo.py` which is already installed in this image. User need to install template to be able to use this feature.  
Go to `Configuration/Templates` and select `Import` and import file located in this repo in `templates-files` directory called `zbx_nginx_template.xml`  

![Nginx1](https://raw.githubusercontent.com/million12/docker-zabbix-server/master/images/nginx1.jpg)  

![Nginx2](https://raw.githubusercontent.com/million12/docker-zabbix-server/master/images/nginx2.jpg)  

More details in official documentation [here](https://github.com/vicendominguez/nginx-zabbix-template).

### PHP-FPM Status Template
PHP-FPM Status template assumes that your Nginx server is configured to serve stats under `/fpm_status` url and port 80. If you you want to use custom port please edit necessary files.

Example of `nginx.conf` file:

    location /fpm_status {
    access_log off;
    allow 127.0.0.1;
    deny all;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_pass php-upstream;
    }  

Installation:  
Go to Configuration/Templates and select Import and import file located in this repo in templates-files directory called `zabbix-php-fpm-template.xml`

Screenshots:  
![PHP-FPM](https://raw.githubusercontent.com/million12/docker-zabbix-server/master/images/php-fpm-stats.jpg)


## Author

Author: Przemyslaw Ozgo (<linux@ozgo.info>)

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
