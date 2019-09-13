# README

This README will cover the required steps to get this back-end running for the [front-end repo](https://github.com/davidma415/bookstore-client).

### Requirements
* Using Ruby >2.2, on Rails >5.2.x
* ngrok (for allowing outside connections to our local development)
* Github API

### Database creation
* Run `rails db:migrate` to setup the database. This will update our schema with the required fields.

* Run `rails db:seed` to add some seed data into the database.

### Configuration
* `git clone <repository-url>` this repository
* `cd bookstore-api`
* `bundle install`

* We are going to be using the Octokit gem to run our requests for the Github API, and the Github Webhook gem to process issues connected to this repo.

* Update the `lib/tasks/create-authors.rake` file with your OAuth token if you have OAuth enabled. Otherwise, you can use basic authorization (the code is commented out).

* Next, use ngrok to setup the tunnel to allow outside connections. ngrok can be downloaded at the following [link](https://ngrok.com/download). Once you have downloaded, change into the directory where you have it downloaded and unzip the file. After unzipping, run `./ngrok http 3000`, since this is the port that our Rails server is running on. Keep note of the url that it generates (ends with ngrok.io);

* Run rails s to start your server, and also start the [front-end client](https://github.com/davidma415/bookstore-client).

### Webhook Configuration
* Visit this [link](https://github.com/davidma415/bookstore-api/settings/hooks) to add your webhook.

* Change the payload url to the `http://[your url here]ngrok.io/github_webhooks`

* Content type will be JSON.

* Enter what you want for the webhook secret. For what you put in here, change the `GITHUB_WEBHOOK_SECRET` in `config/app_environment_variables.rb` to what you put in this field.

* For events, we only want issues.

* Once you add this webhook, the Rails server should be running along with ngrok. With this all setup, we should be able to run `rake create_authors` to populate the repo with some issues.

* Visit [https://localhost/4200](https://localhost/4200) to see your bookstore with the seed data and the books that were created from the rake task.

* Any edits to the issue title will update the `Author` name, and changes to the description will update the `Author` biography.

* If you delete an issue, the author and corresponding books will also be deleted.
