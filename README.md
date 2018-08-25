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
4. Start the server with `rails s` or 'rails s -b 0.0.0.0' for MacOS.
5. In a new terminal tab run `bundle exec sidekiq`.
5. The first registered user will be given admin rights by default.

## Workflow
To start a constest on the app, first a setter has to be made. Only a admin can appoint a setter. Then a setter can host a contest. A contest can have many problems in it. A problem will have associated languages and many submission by different users.

Note: When creating a language make sure to use the name provided by the codemirror modes E.g for C language.name="text/x-csrc", the language code could be the language name we generally use like C/C++, JAVA
