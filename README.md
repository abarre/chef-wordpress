# Wordpress install with chef

##installation

vagrant plugin : 
- vagrant-digitalocean
- vagrant-librarian-chef (if necessary)
- vagrant-omnibus

- add the password in the data_bags : 
```
knife solo data bag show pass lovelycarte

{
	"id":lovelycarte,
	"server":"PASS",
  	"mysql"=>"PASS"
}
```

## start the project