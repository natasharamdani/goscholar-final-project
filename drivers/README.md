# Go-Food using Ruby on Rails

This README would document whatever steps are necessary to get the application up and running.

## Prerequisites

What things you need to install the software and how to install them.

### Installing Rails using RVM

The easiest way to install Rails is using RVM, which also installs Ruby. To install RVM you will need to ensure your system has curl installed. RVM also installed the Rails Gem for us.

```
sudo apt-get install curl
```

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
```

### Installing Rails using Gem

```
gem install rails
```

### Installing Postgres

```
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-9.6
```

#### Setting Up Postgres

Run Postgresql

```
sudo -u postgres psql
```

Set the Postgresql password

```
postgres=# \password
```

Create new user, with "myapp" as the project name

```
postgres=# create role myapp with createdb login password 'yourpassword';
\q
```

## Rails App

A step by step that tell what you have to do to get a development environment running.

### Creating a Rails App configured for Postgres

```
rails new myapp --database=postgresql
```

### Install the pg gem so that you can interface with Postgres from Ruby code

```
gem install pg
bundle install
```

### Configuring database file RAILS_ROOT/config/database.yml

```
development:
database: myapp_development
username: myapp
password: yourpassword
host: localhost

test:
database: myapp_test
username: myapp
password: yourpassword
host: localhost
```

### Create Database

```
rails db:migrate
rails db:setup
```

### Run Rails Server

```
rails server
```

Navigate to localhost:3000

#### If countered error, install therubyracer gem. Run the Server again

```
gem install therubyracer
bundle install
```