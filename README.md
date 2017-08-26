# Online Judge [![Build Status](https://travis-ci.org/kumarneetesh24/OnilineJ.svg?branch=master)](https://travis-ci.org/kumarneetesh24/OnilineJ)

-> Online Judge inspired from [revi-oj](https://github.com/eh2arch/revi_oj)

## About
OnlineJ is an online code judge which can be used to hold coding contests online. It is developed and maintained by the GNU/Linux Users' Group NIT Durgapur. The project is inspired . The main aim of the project is to promote the culture of competitive coding in instituions like schools,colleges and university by providing them with the tool to host coding contest according to their rules and regulations. The code judge is currently capable of judging codes in all languages. The most frequetly used languages like C,C++,Python,JAVA,Ruby are already added to the judge. If requried other languages can be added easily by follow the guide mentioned here.

## Prerequisites

### RubyonRails
OnlineJ is built on Ruby with Rails as the web framework. To the get app up and running you need to have Ruby and Rails install on your local machine or the server. Follow this [guide](http://railsapps.github.io/installrubyonrails-ubuntu.html) to set up RubyonRails

### MongoDB
The database used in the app is MongoDB, so it must be configured on you local machine. Follow the [guide](https://docs.mongodb.com/manual/administration/install-on-linux/) if you dont have MongoDB installed

### Redis
Get Redis install and running on your machine follow the [guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis)

## Setting Up
1. Run `git clone `
2. Inside the clone directory run `bundle install` to install all the gems.
3. Run `bundle exec rake judge:init` to build  the code judge.
4. Start the server with `rails s`.
5. In a new terminal tab run `bundle exec sidekiq`.
5. The first registered user will be given admin rights by default.

## Workflow
To start a constest on the app, first a setter has to be made. Only a admin can appoint a setter. Then a setter can host a contest. A contest can have many problems in it. A problem will have associated languages and many submission by different users.

Note: When creating a language make sure to use the name provided by the codemirror modes E.g for C language.name="text/x-csrc", the language code could be the language name we generally use like C/C++, JAVA

## Deployment/production
OnlineJ uses puma as a rack server to host it in production you will need a web server like Apache or Nginx. We highly recommend Nginx, as it is a fast reverse proxy web server with support for multiple apps and extra cool feature. So below is a step-wise guide to host the app in production on a Ubuntu 16.06 LTS operating system with Puma and Nginx

1. Assuming your app is running all fine in development
2. Install Nginx `sudo apt-get install nginx`
3. Run `rake secret` and use this key in `config/secrets.yml` for production secret_key_base
4. Comment out the line starting with `config.secret_key` in `config/initializers/devise.rb` and use the same key
5. Run `RAILS_ENV=production rake assets:precompile` to precompile assets for production

### Puma Configuration
1. Run `mkdir -p shared/pids shared/sockets shared/log`
2. Edit `config/puma.rb` with

```
# Change to match your CPU core count
# To check CPU count grep -c processor /proc/cpuinfo
workers 2

# Min and Max threads per worker
threads 1, 6

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix://#{shared_dir}/sockets/puma.sock"

# Logging
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app

# on_worker_boot do
# require "active_record"
#  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
#  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])*/
end
```
### Nginx Configuration
1. make the configuration for nginx in `/etc/nginx/nginx.conf` replace user with your user name

```
#user html;
worker_processes  1; # this may connect with the worker numbers puma can use.

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}

http {
	upstream app {
	    # Path to Puma SOCK file, as defined previously
 	    server unix:/home/user/OnlineJ/shared/sockets/puma.sock;
	}

	server {
	    listen 80;
	    server_name localhost; # or your server name

	    root /home/user/OnlineJ/public/assets/;

	    try_files $uri/index.html $uri @app;

	    location @app {
		proxy_pass http://app;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
		proxy_redirect off;
	    }

	    error_page 500 502 503 504 /500.html;
	    client_max_body_size 4G;
	    keepalive_timeout 10;
	}
}
```
### Starting server
1. Start nginx with `sudo systemctl start nginx`
2. Start puma with `bundle exec puma -C config/puma.rb -d` -d specifes to run as daemon
3. Start sidekiq with `bundle exec sidekiq -d`
>To kill Puma server run killall bundle
