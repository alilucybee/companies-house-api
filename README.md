# README

This Rails app gets a list of Companies, makes a request to the [Companies House API](https://developer.company-information.service.gov.uk/get-started) to get the address data, saves the information in a database and allows users to globally like companies.

### Running locally

System dependencies:

This project uses Rails 6.1.7 and was created with Ruby 3.0.3.

- Follow the [Getting Started with Rails](https://guides.rubyonrails.org/v6.1/getting_started.html) guide "3.1 Installing Rails" to make sure you have Ruby, SQLite3, Node and Yarn installed

From the root directory of the project run:

* `bundle install` to download dependencies from the Gemfile
* `yarn install` to download yarn packages
* Create the database by running `rails db:create db:migrate`

Set up your environment variables by copying the `.env_example` file and saving this copied file as your own `.env` in the root directory. The only value you need to replace is the API_KEY to connect to Companies House. You can create your own token following the instructions in the Companies House link above.

And finally:
* run `rails server` (or rails s) to run the app locally on "http://localhost:3000"

Testing:

Rails tests can be run with `rails test`

You can also open a `rails console` if you want to check the companies that have been saved in the database, eg using `Company.first` or `Company.all`