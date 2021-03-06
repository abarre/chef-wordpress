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

Credential file : create a file `default.rb` in `site-cookbooks/credential/attributes` that contains the content of the default.example.rb file.
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

```
vagrant plugin install vagrant-managed-servers
vagrant up wordpress_dedibox --provider=managed

# update a machine
```
vagrant provision wordpress_dedibox
``

