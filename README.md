# Wordpress installation with chef and vagrant

Install wordpress on nginx + mod_pagespeed + php-fpm + mysql.

Tested on ubuntu 12.04 (vagrant and on a digital ocean droplet)

## Requirement
vagrant 3+


##installation

vagrant plugin :
- vagrant-digitalocean
- vagrant-librarian-chef (optional)
- vagrant-omnibus (for chef)

- add the password in the data_bags :
```
knife solo data bag create pass lovelycarte
```

```json
{
	"id":"lovelycarte",
	"server":"PASS",
  	"mysql":"PASS"
}
```

```
knife solo data bag create certificate lovelycarte
```

```json
{
	"id":"lovelycarte",
	"cert":"CERT",
	"key":""
}
```

## create a machine

```
bundle
librarian-chef install

vagrant box add precise64 http://files.vagrantup.com/precise64.box

vagrant up
vagrant up --provider=digital_ocean
vagrant destroy
vagrant provision
```