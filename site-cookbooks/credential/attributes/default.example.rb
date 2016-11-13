default[:admin][:email] = ""
default[:admin][:email_password] = ""

override[:ssmtp][:root] = ""
override[:ssmtp][:auth_username] = ""
override[:ssmtp][:auth_password] = ""
override[:ssmtp][:hostname] = ""


override[:newrelic][:server_monitoring][:license] = ""
override[:newrelic][:application_monitoring][:license] = ""

default[:backup][:ip] = ""

override[:backup_manager][:upload_ftp_user] = ''
override[:backup_manager][:upload_ftp_password] = ''
override[:backup_manager][:upload_ftp_host] = ''
