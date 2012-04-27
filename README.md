# time_tracker_service

This is basic a web service built on Rails, intended to illustrate step-by-step how to create
and deploy a marginally useful simple web service from scratch.  It provides a
REST service for keeping track of your hours.  A user can create, read, update, and
delete records that contain the following data:
* Project Name
* Task Name
* Date on which the task was performed
* Time (in hours) spent performing task
* Notes

There are also admin privileges baked in - an admin can create, read, update, and delete users.


# Features
* REST API's (Create, Read, Update, Delete via HTTPS)
* JSON and XML supported
* Solid MVC architecture
* Secure (Basic-Auth over HTTPS, encrypted passwords stored in database)
* Multi-user, admin privileges
* web interface to create, read, update, and delete users and tasks

# Limitations
* No sign-up (new users must be added by admin)
* Very basic web pages (no CSS styling, no pages for summaries, charts, etc)
* No tests

# Requirements
* Ruby 1.9.2 (RVM works well: https://rvm.io/)
* Rails 3.2.3 (gem install rails)
* Optionally a local database (Postgres OS X install can be found at http://www.postgresql.org/download/macosx/).
* Heroku toolbelt for deployment to web: https://toolbelt.herokuapp.com/

# Steps
1. Create a new Rails project using Postgres for the database.  Postgres is chosen because we'll deploy on Heroku (http://www.heroku.com/) which offers a free 5MB shared Postgres database.
>rails new time_tracker_service -d postgresql

1. Add the bcrypt gem, which will allow us to store encrypted passwords in the database Gemfile:
<pre><code>
gem 'bcrypt-ruby'
</code></pre>

1. Install the bundle with new Gem:
>bundle install

1. Create the User scaffolding, which generates the model, controller, and views for a user:
>rails generate scaffold User name:string email:string password:string password_digest:string admin:boolean --no-test-framework

1. Create the Task scaffolding, which generates the model, controller, and views for a task:
>rails generate scaffold Task project_name:string task_name:string performed_on:date hours:float notes:text user:references  --no-test-framework

1. take a look at the routes - as you can see all of the CRUD endpoints have been created for us:
>rake routes

1. Modify app/models/user.rb to make 1-to-many mapping from a user to tasks, as well as adding secure password support:
<pre><code>
    class User &lt; ActiveRecord::Base
      has_secure_password
      has_many :tasks
      ...
    end
</code></pre>

1. Recreate database:
> bundle exec rake db:migrate   
> bundle exec rake db:reset  #if we want to clear it out

1. Add an authentication method in app/controllers/application_controller.rb.  This will check to see if the user is already authenticated, and if not will return an unauthorized response.  It optionally checks to see if a user has admin privileges:
<pre><code>
    def authenticate(adminCheck=false)
      authenticate_or_request_with_http_basic('Login') do |username, password|
          @user = User.find_by_email(username)
          if adminCheck == true
               @user && @user.authenticate(password) && @user.admin
          else
               @user && @user.authenticate(password)
          end
      end
    end
</code></pre>

1. Modify the users_controller.rb and tasks_controller.rb to perform authentication prior to performing a request:
<pre><code>
    before_filter do |controller|
        authenticate(true) #true for users_controller.rb, false for tasks_controller.rb
    end
</code></pre>

1. Update app/controllers/tasks_controller.rb to perform CRUD only on tasks owned by the logged-in user:
<pre><code>
    def index
        @tasks = Task.find_all_by_user_id(@user.id)
        ...
    def show
        @task = Task.find(:first, :conditions => {:user_id => @user.id, :id => params[:id]})
        ...
    def new
        @task = @user.tasks.build(params[:task])
        ...
    def edit
        @task = Task.find(:first, :conditions => {:user_id => @user.id, :id => params[:id]})
        ...
    def create
        @task = @user.tasks.build(params[:task])
        ...
    def update
        @task = Task.find(:first, :conditions => {:user_id => @user.id, :id => params[:id]})
        ...
    def destroy
        @task = Task.find(:first, :conditions => {:user_id => @user.id, :id => params[:id]})
        ...
</code></pre>

1. Update app/views/users/_form_html.erb to remove the password hash field, since we want the has_secure_password to save the hash for us.  Remove this:
<pre><code>
  &lt;div class="field"&gt;
    &lt;%= f.label :password_digest %>&lt;br /&gt;
    &lt;%= f.text_field :password_digest %&gt;
  &lt;/div&gt;
</code></pre>

1. Update app/views/tasks/_form.html.erb so we can add new tasks from the web interface.  This is necessary because the controller is getting the user from who is currently logged in, and attempting to set it via form data will result in an error.  Remove this:
<pre><code>
  &lt;div class="field"&gt;
    &lt;%= f.label :user %>&lt;br /&gt;
    &lt;%= f.text_field :user %&gt;
  &lt;/div&gt;
</code></pre>


1. Test it locally:
>rails s

1. Deploy!
>heroku create --stack cedar timetrackerservice   
>git push heroku master  
>heroku run rake db:migrate  

1. Add admin user on remote machine via <tt>heroku run console</tt>:
<pre><code>
     me = User.new(name: "Mike V", email: "mikev@duffresearch.com", admin: true)
     me.password = "foobar"
     me.save
</code></pre>

# Resources
http://guides.rubyonrails.org/  - getting started is pretty comprehensive   
http://ruby.railstutorial.org/ - very detailed and up to date tutorial for building a twitter client   
https://www.coursera.org/course/saas (next session starts in May) - Looks like a great course from Berkeley U   

