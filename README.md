# magebr-docker

[![N|Solid](https://magebr.com/sites/default/files/Logo.png)](https://magebr.com/)

This docker was created so you can run your code locally. This only works with Magento 1 (CE and EE).
Follow the steps below to get it all set up!

### Requirements
* Docker CE (tested on Linux and MacOS) - https://docs.docker.com/install/
* docker-compose - https://docs.docker.com/compose/install/
* MySQL Client (needed to import the database) or:
    * Sequel PRO for Mac - https://www.sequelpro.com/
    * MySQL WorkBench for Mac, Windows or Linux - https://www.mysql.com/products/workbench/
* Git (terminal)

### Installation
Any of the steps below can be changed to your folder.
First we need to create a folder where we will clone your repo:
```
mkdir -p ~/Sites/magento/my-repo/
```

Next step is to clone this repo:
```
git clone git@github.com:CajuCLC/docker-magento.git ~/Sites/magento/magebr-docker-magento
```

We also need to clone your repo to your folder, make sure you change it here:
```
git clone git@github.com:MYUSER/my-repo.git ~/Sites/magento/my-repo
```

Now the easy step, start the containers!
```
cd ~/Sites/magento/magebr-docker-magento
docker-compose up -d
```

When you start for the first time it might take some time to download and extract the image. While you wait you can open a new terminal and a domain for your local environment. As other commands, you can change to whatever you would like.
```
sudo -- sh -c "echo 127.0.0.1 local.mymagento.com >> /etc/hosts"
```

We are almost done, we need to import the database locally. You must have some MySQL client installed.
First you need to get the MySQL port:
```
docker ps
```

It will show something like this:
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                      NAMES
d1ab04ca0b04        mysql:5.6           "docker-entrypoint.s…"   12 seconds ago      Up 7 seconds        0.0.0.0:32812->3306/tcp                    magebr-magento-db
790cc90177fe        redis:3.2           "docker-entrypoint.s…"   12 seconds ago      Up 6 seconds        0.0.0.0:32810->6379/tcp                    magebr-magento-session
e29c36cdbd8f        redis:3.2           "docker-entrypoint.s…"   12 seconds ago      Up 8 seconds        0.0.0.0:32811->6379/tcp                    magebr-magento-fpc
93743f8a890f        cajuclc/magento     "docker-php-entrypoi…"   12 seconds ago      Up 9 seconds        0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   magebr-magento-web
43951fdab672        redis:3.2           "docker-entrypoint.s…"   12 seconds ago      Up 10 seconds       0.0.0.0:32809->6379/tcp                    magebr-magento-cache
```

In this example MySQL is on port 32812, to import the database run the command below (make sure you move the database file to the same folder):
```
mysql -u root -proot -P [PORT] -h 127.0.0.1 magento < ~/Sites/magento/database/database.sql
```

The last step is to configure the local.xml file. We offer two options, one without Redis cache and session and one with them configured.
They are both inside resources folder (https://github.com/CajuCLC/docker-magento/tree/master/resources)
```
With Redis: default.local.redis.xml
Without Redis: default.local.xml
```

Just pick one and copy to your repo folder, command will look like this:
* With Redis
```
~/Sites/magento/magebr-docker-magento/resources/default.local.redis.xml ~/Sites/magento/my-repo/app/etc/local.xml
```

* Without Redis
```
~/Sites/magento/magebr-docker-magento/resources/default.local.xml ~/Sites/magento/my-repo/app/etc/local.xml
```

That should be it. Have fun coding locally!
