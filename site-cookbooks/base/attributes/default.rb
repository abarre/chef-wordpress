default[:monit][:notify_email]          = default[:admin][:email]

default[:monit][:poll_period]           = 60
default[:monit][:poll_start_delay]      = 20

default[:monit][:mail_format][:subject] = "$SERVICE $EVENT"
default[:monit][:mail_format][:from]    = default[:admin][:email]
default[:monit][:mail_format][:message]    = <<-EOS
Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit
EOS

default[:monit][:mailserver][:host] = "smtp.gmail.com"
default[:monit][:mailserver][:port] = "587"
default[:monit][:mailserver][:username] = default[:admin][:email]
default[:monit][:mailserver][:password] = default[:admin][:email_password]
default[:monit][:mailserver][:password_suffix] = "using tlsv1 with timeout 30 seconds"

default[:ssmtp][:mailhub_name] = 'smtp.gmail.com'
default[:ssmtp][:credential_method] = 'plain'
default[:ssmtp][:auth_enabled] = true
default[:ssmtp][:use_tls] = false
default[:ssmtp][:from_line_override] = true
default[:ssmtp][:rewrite_domain] = false

default[:backup_manager][:tarball_directories] = ["/etc", "/home", "/var/www"]
default[:backup_manager][:upload_method] = "ftp"

default[:backup_manager][:upload_ftp_secure] = 'false'
default[:backup_manager][:upload_ftp_passive] = 'true'
default[:backup_manager][:upload_ftp_purge] = 'true'
default[:backup_manager][:upload_ftp_ttl] = '5'
default[:backup_manager][:upload_ftp_destination] = '/'

override[:backup_manager][:mysql_adminpass] = node[:mysql][:server_root_password]
default[:certbot][:webroot_dir] = "/var/www"
