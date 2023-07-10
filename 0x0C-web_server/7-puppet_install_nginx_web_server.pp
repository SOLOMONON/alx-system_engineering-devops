# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Configure Nginx to listen on port 80 and serve the desired content
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => "server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
      try_files \$uri \$uri/ =404;
    }

    location = /redirect_me {
      return 301 http://example.com/new_page;
    }
}
",
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Create a default index.html file
file { '/var/www/html/index.html':
  ensure  => file,
  content => 'Hello World!',
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure    => running,
  enable    => true,
  hasstatus => true,
}

