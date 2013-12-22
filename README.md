# Wordpress installation with chef and vagrant

Install wordpress on a apache2 installation with mysql.

Tested on ubuntu 12.04 (vagrant and on a digital ocean droplet)

## Requirement
vagrant 3+


##installation

vagrant plugin :
- vagrant-digitalocean
- vagrant-librarian-chef
- vagrant-omnibus (for chef)

- add the password in the data_bags :
```
knife solo data bag show pass lovelycarte
```

```json
{
	"id":"lovelycarte",
	"server":"PASS",
  	"mysql":"PASS"
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

## details

### apache
installed from the packages with the following mode :
- mod_deflate
- mod_expires
- mod_php5
- mod_pagespeed

Configuration of mod_pagespeed :
```
ModPageSpeed on
ModPagespeedRewriteLevel CoreFilters
ModPagespeedEnableFilters prioritize_critical_css
ModPagespeedEnableFilters defer_javascript
ModPagespeedEnableFilters sprite_images
ModPagespeedEnableFilters convert_png_to_jpeg,convert_jpeg_to_webp
ModPagespeedEnableFilters collapse_whitespace,remove_comments
```
