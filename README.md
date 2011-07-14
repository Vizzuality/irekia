IREKIA
======

1. Installation
---------------

- Download the repository:

		$ git clone git@github.com:Vizzuality/irekia.git

- Install bundler gem and install all project's gems:

		$ gem install bundler && bundle install
		
- And finally, set up the database:

		$ rake db:setup
		
Notes (only for development/staging environments)
-------------------------------------------------

There's a default administrator user. His credentials are:

email:

	admin@example.com
password:

	example

---

To manage the app data, go to:

	http://localhost:3000/admin
	
You'll need to be signed in as administrator to be able to enter this zone. From here, you'll be able to manage users (create, edit and delete them), and moderate contents and participation.

Also, you can visit:

	http://localhost:3000/areas/1

or

	http://localhost:3000/politics/1
	
From the politic page, you would be able to make a question to that politic.