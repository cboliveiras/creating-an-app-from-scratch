Passo a passo para criar uma aplicação do zero (usando postgres, rspec e docker)

# Passo 1

Criar a aplicação usando postgres no modo API

rails new app --database=postgresql --skip-javascript --api --skip-asset-pipeline --skip-test --skip-hotwire --skip-jbuilder --skip-action-cable

# Passo 2

Instalar as gemas necessárias:
	group :development, :test do
		- gem 'pry-byebug'
		- gem 'rspec-rails'
		- gem 'shoulda-matchers'
	end
