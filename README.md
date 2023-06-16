Passo a passo para criar uma aplicação do zero (usando postgres, rspec e docker)

## Passo 1

Criar o repositório no github e depois clonar o SSH dentro da sua pasta no computador usando
```git clone SSH_key```

## Passo 2

Criar a aplicação usando postgres no modo API

```
rails new app --database=postgresql --skip-javascript --api --skip-asset-pipeline --skip-test --skip-hotwire --skip-jbuilder --skip-action-cable
```

## Passo 3

Instalar as gemas necessárias
	```
	group :development, :test do
		- gem 'pry-byebug'
		- gem 'rspec-rails'
		- gem 'shoulda-matchers'
	end
	```

Rodar ```bundle install```

## Passo 4

Alterar o config/database.yml. No caso do postgres, é necessário que seja:

```
	default: &default
  adapter: postgresql
  username: postgres
  password: password
  pool: 5
  host: localhost


	development:
		<<: *default
		database: app-name_development

	test:
		<<: *default
		database: app-name_test
```

Dar um ```rails db:create && rails db:migrate```

Caso precise trocar a senha do postgres, usar o comando ```sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'new_password';"```

## Passo 5

Dockerizando a aplicação:

1. Criar o docker-compose.yml
2. Nele, colocar:
```	version: "3.3"
  	services:
    	db:
      	image: postgres
      	volumes:
        	- ./tmp/db:/var/lib/postgresql/data
       	environment:
        	POSTGRES_PASSWORD: password

     	web:
       	build: .
       	command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
       	volumes:
         	- .:/app-name
       	ports:
         	- "3000:3000"
       	depends_on:
         	- db
       	stdin_open: true
       	tty: true
		```
3. Criar o Dockerfile
4. Nele, colocar
  ```
		FROM ruby:3.1.2
		RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
		WORKDIR /app-name
		COPY Gemfile /app-name/Gemfile
		COPY Gemfile.lock /app-name/Gemfile.lock
		RUN bundle install
		COPY . /app-name

		EXPOSE 3000
	```

## Passo 6

Agora, precisamos buildar o nosso ambiente.

1.  Instalar o docker-compose, caso não tenha:
``` sudo apt update && sudo apt install docker-compose ```
1. Instalar o docker, usando a documentação oficial
2. Dar permissão para o usuário dar build na aplicação com ```sudo usermod -aG docker your_username```
O username você pode encontrar digitando ```whoami``` no terminal. Para essas modificações fazerem efeito, você deve reiniciar o notebook.
1. ```docker build -t app-name .```
2. Dar um up no projeto com ```docker-compose up```
3. Criar o banco de dados com ```docker-compose run web rake db:create db:migrate```
4. Testar a aplicação com ```docker-compose run web rake spec PGUSER=postgres RAILS_ENV=test```
