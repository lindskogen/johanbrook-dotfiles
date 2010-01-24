#Most snippets of code here was stolen from Jeff Schoolcraft ~~his github page here~~
def download(from, to = from.split("/").last)
  run "curl -sL #{from} > #{to}"
  file to, open(from).read
# rescue Need to add my own local stuff later
#   puts "Can't get #{from} - Internet down?"
#   puts "Trying local, ~/code/rails-template/"
#   run "cp ~/code/rails-template/#{from} #{to}"
end
 
def from_repo(github_user, from, to = from.split("/").last)
  download("http://github.com/#{github_user}/rails-template/raw/master/#{from}", to)
end
 
def commit_state(comment)
  git :add => "."
  git :commit => "-am '#{comment}'"
end

app_name = File.basename(File.expand_path(root))
git :init

sudo_asked = ask("Do you want to install gems with Sudo?")
sudo_asked = true if sudo_asked == "yes" or sudo_asked == "y" or sudo_asked == ""
sudo_asked = false if sudo_asked == "n" or sudo_asked == "no"
run "echo 'TODO add readme content' > README"
run "echo 'TODO add readme content' > doc/README_FOR_APP"
run "rm -rf config/database.yml"
file "config/database.yml", %Q{
defaults: &defaults
  adapter: mysql
  encoding: utf8
  host: localhost
  username: root
  password:

development: &development
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000

test: &TEST
  <<: *development
  database: db/test.sqlite3
  
cucumber:
  <<: *TEST
   
production:
  <<: *defaults
  database: #{app_name}
}
run "cp config/database.yml config/example_database.yml"

run "rm public/index.html"
run "rm public/images/rails.png"
run "rm -f public/javascripts/*"
run "rm -f public/favícon.ico"


file ".gitignore", <<-CODE
log/*.log
tmp/**/*
db/*.sqlite3
.DS_Store
public/stylesheets/*.css
public/stylesheets/sass/*.css
config/database.yml
CODE
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
commit_state("Removed public junk, *css files, using shoulda with T::U and Cucumber. Also created .gitignore file for logs, tmp, database stuff. Generated database.yml config, uses sqlite3 for dev, test and cucumber. MySQl with prod")

gem "nifty-generators", :lib => false, :source => 'http://gemcutter.org'
gem "authlogic", :source => 'http://gemcutter.org'
gem "searchlogic", :source => 'http://gemcutter.org'
gem "cancan", :source => 'http://gemcutter.org'
gem "RedCloth", :source => 'http://gemcutter.org'
gem "annotate", :source => 'http://gemcutter.org'
gem "slim_scrooge", :source => 'http://gemcutter.org'
gem "paperclip", :source => 'http://gemcutter.org'
gem "haml", :source => 'http://gemcutter.org'
gem "validation_reflection", :source => 'http://gemcutter.org'
gem "formtastic", :source => 'http://gemcutter.org'
gem "will_paginate", :source => 'http://gemcutter.org'
gem "acts-as-taggable-on", :source => 'http://gemcutter.org'
#gem "vestal_versions", :source => 'http://gemcutter.org'
#gem "gravtastic", :source => 'http://gemcutter.org'
gem "inherited_resources", :source => 'http://gemcutter.org' 
gem "compass", :lib => false, :version =>"0.10.0.pre5", :source => 'http://gemcutter.org'
gem "fancy-buttons", :lib => false
rake "gems:install", :sudo => sudo_asked
commit_state("Installed gems, check template for a list")
%w(test).each do |environment|
  gem 'cucumber', :lib => false, :source => 'http://gemcutter.org', :env => environment
  gem 'cucumber-rails', :lib => false, :source => 'http://gemcutter.org', :env => environment
  gem 'webrat', :lib => false, :source => 'http://gemcutter.org', :env => environment
  gem 'factory_girl', :source => 'http://gemcutter.org', :env => environment
  gem 'mocha', :source => 'http://gemcutter.org', :env => environment
  gem 'shoulda', :source => 'http://gemcutter.org', :env => environment
  gem 'email_spec', :source => 'http://gemcutter.org', :env => environment
  gem 'faker', :source => 'http://gemcutter.org', :env => environment
  gem 'populator', :source => 'http://gemcutter.org', :env => environment
  rake 'gems:install', :sudo => sudo_asked, :env => environment
  commit_state("Testing gems installed for #{environment}")
end
# 
# if yes?("Do you want twitter gem?")
#     gem "intridea-tweetstream"
# end
# 
# if yes?("Do you want aasm gem?")
#     gem "aasm"
# end
# 
# if yes?("Do you want Mechanize and Nokogiri gem?")
#     gem "nokogiri"
#     gem "mechanize"
# end
# 
# if yes?("Do you want Prawn (pdf) gem?")
#     gem "prawn"
# end
# 
# if yes?("Do you want Hirb gem?")
#     gem "hirb"
# end
# if yes?("Do you want Prowl (growl) gem?")
#     gem "prowl"
# end
# 
# if yes?("Do you want to deploy with heroku?")
#   gem "heroku"
# end
# 
# if yes?("Do you want to deploy with capistrano?")
#   gem "capistrano"
# end

generate :vestal_versions_migration
generate :nifty_scaffold, "Image", "imaginable_id:integer", "imaginable_type:string", "--haml", "--skip-controller"
run "rm -rf /app/views/images"
file "app/models/image.rb", <<-CODE
class Image < ActiveRecord::Base
  belongs_to :imaginable, :polymorphic => true
    has_attached_file :photo,
                    :styles => {
                    :thumb=> "100x100#",
                    :small  => "150x150>",
                    :medium => "300x300>",
                    :large =>   "500x500>",
                    :xlarge =>   "600x600>",
                    :xxlarge =>   "800x800>",
                    :url  => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/:id/:style/:basename.:extension"
                    #edit path to your liking
                    }
                    
validates_attachment_presence :photo
validates_attachment_size :photo, :less_than => 5.megabytes
validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end
CODE

file "app/controllers/images_controller.rb", <<-CODE
class ImagesController < ApplicationController
  def index
    @imaginable = find_imaginable
    @images = @imaginable.images
  end
  
  def create
    @imaginable = find_imaginable
    @image = @imaginable.images.build(params[:image])
    if @image.save
      flash[:notice] = "Successfully uploaded image."
      redirect_to :id => nil
    else
      render :action => 'new'
    end
  end
  
  private
  
  def find_imaginable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end

CODE
generate :paperclip, "Image", "photo"
commit_state("Fixed vestal_version (add) and polymoprhic paperclip Image, need to edit the controller and add views also edit the :path and :url in the model")

initializer 'haml_and_sass.rb', <<-CODE
begin
  require File.join(File.dirname(__FILE__), 'lib', 'haml') # From here
rescue LoadError
  begin
    require 'haml' # From gem
  rescue LoadError => e
    # gems:install may be run to install Haml with the skeleton plugin
    # but not the gem itself installed.
    # Don't die if this is the case.
    raise e unless defined?(Rake) && Rake.application.top_level_tasks.include?('gems:install')
  end
end

# Load Haml and Sass.
# Haml may be undefined if we're running gems:install.
Haml.init_rails(binding) if defined?(Haml)
CODE
commit_state("Added haml initializer")

run "compass --rails -f blueprint . --sass-dir app/stylesheets --css-dir public/stylesheets --images-dir public/images --javascripts-dir public/javascripts --output-style compressed --relative-assets"
run "echo 'cache_dir = %Q[tmp/sass-cache]\nrequire %Q[compass-colors]\nrequire %Q[fancy-buttons]' >> config/compass.rb"
#run "echo 'cache_dir = %Q[tmp/sass-cache]' >> config/compass.rb"
run "compass -r compass-colors -f fancy-buttons ."
commit_state("Added compass to project with blueprint app/stylesheets, public/stylesheets. Using compressed form as well as relative assets in config")
commit_state("Also added compass-colors and fancy-buttons")
generate "formtastic"
run "rm -f public/stylesheets/formtastic*"
commit_state("Added formtastic initializer, but removed formtastic css")

generate :nifty_layout, "--haml"
file "app/views/layouts/application.html.haml", <<-CODE
!!! Strict
%html{html_attrs}
  
  %head
    %title
      = h(yield(:title) || "Untitled")
    %meta{"http-equiv"=>"Content-Type", :content=>"text/html; charset=utf-8"}/
    = stylesheet_link_tag 'application'
    = javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jquery/1.4.0/jquery.min.js", "http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js", "application", :cache => true
    = yield(:head)
  
  %body
    #container
      - flash.each do |name, message|
        %div{:id => "flash_\#{name}"}
          msg
      
      - if show_title?
        %h1=h yield(:title)
      
      = yield

CODE
commit_state("Created a layout with helpers, modified it, added jQuery from Gooles ajax libs. Using jQuery 1.4 and UI 1.7.2")

run "cp ./public/stylesheets/sass/application.sass ./app/stylesheets/screen.sass"
run "mv ./public/stylesheets/sass/application.sass ./app/stylesheets/application.sass"
run "rm -rf /public/stylesheets/sass"
commit_state("Moved application.sass from public/stylesheets/sass to app/stylesheets and renamed to main.sass. Need to import modules and skintastic")
run "git clone git://github.com/morgoth/formtastic-sass.git"
inside("formtastic-sass") do
  run "mv *.sass ../app/stylesheets/partials/"
end
run "rm -rf formtastic-sass"
commit_state("Added application layout and moved formtastic sass to the app/stylesheets/partials. Need to import skintastic to screen.sass")



generate "cucumber", "--webrat"
file "config/environments/cucumber.rb", <<-CODE
# Edit at your own peril - it's recommended to regenerate this file
# in the future when you upgrade to a newer version of Cucumber.
# IMPORTANT: Setting config.cache_classes to false is known to
# break Cucumber's use_transactional_fixtures method.
# For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165
config.cache_classes = true
# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true
# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false
# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test
config.gem 'cucumber', :lib => false, :source => 'http://gemcutter.org'
config.gem 'database_cleaner', :lib => false
config.gem 'cucumber-rails', :lib => false, :source => 'http://gemcutter.org'
config.gem 'webrat', :lib => false, :source => 'http://gemcutter.org'
config.gem 'shoulda', :source => 'http://gemcutter.org'
config.gem 'factory_girl', :source => 'http://gemcutter.org'
config.gem 'email_spec', :source => 'http://gemcutter.org'
config.gem 'faker', :source => 'http://gemcutter.org'
config.gem 'mocha', :source => 'http://gemcutter.org'
config.gem 'populator', :source => 'http://gemcutter.org'
CODE
rake 'gems:install', :sudo => sudo_asked, :env => "cucumber"
run "mkdir test/factories"
commit_state("Testing gems installed for cucumber")
commit_state("generated cucumber")

environment "config.middleware.use 'Rack::Honeypot', HONEYPOT_FIELD_NAME"
environment "HONEYPOT_FIELD_NAME = '#{app_name}'"

file "lib/rack/honeypot.rb", <<-CODE
module Rack
  class Honeypot
 
    def initialize(app, field_name)
      @app = app
      @field_name = field_name
    end
 
    def call(env)
      form_hash = env["rack.request.form_hash"]
 
      if form_hash && form_hash[@field_name] =~ /\S/
        [200, {'Content-Type' => 'text/html', "Content-Length" => "0"}, []]
      else
        @app.call(env)
      end
    end
    
  end
end
CODE

file "app/stylesheets/partials/_honeypot.sass", <<-CODE
.#{app_name} { display: none; }
CODE
commit_state("Create honeypot for bots")
##Fix sessions and users
generate :nifty_scaffold, "user", "username:string", "email:string", "role:string", "crypted_password:string", "password_salt:string", "persistence_token:string", "new", "edit", "--haml"
commit_state("User created with haml with a migration")
commit_state("Added User migration, added crypted_password, password_salt and persistence_token ")

file "app/models/user.rb", <<-CODE
class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation, :role, :online
  acts_as_authentic do |session|
      session.logged_in_timeout = 30.days.from_now
  end
  is_gravtastic :email, :secure => true,
                        :filetype => :png,
                        :size => 120
  has_many :posts

  ROLES = %w[admin moderator user guest]
  def role_symbols
    [roles.to_sym]
  end
  
  def role?(given_role)
    self.role == (given_role.to_s)
  end
  
  def activate_guest!
    self.role == "user"
  end
  
end
CODE
commit_state("User model now has ROLES, defaults are admin, moderator, user and guest. Method role? exists now. role? :guest. Also has gravtastic and acts as authenticated with configuration for session time")

file "app/controllers/users_controller.rb", <<-CODE
class UsersController < ApplicationController
    before_filter :current_user, :only => [:show, :edit]
    #before_filter :update_user_on_create, :only => [:create]
    load_and_authorize_resource
    
  def show  
  end
  
  def index
    @users = User.all
  end
  
  def new
    @user = current_user #the user might have any child objects, this can be a good way.
    @user.username = ""
    @user.email = ""
  end
  
  def edit
    @user = current_user
    
  end
  
  def create
    update and return if current_user
    # @user = User.new(params[:user])
    # if @user.save
    #   UserSession.create(@user,true)
    #   redirect_to posts_path
    # else
    #   render 'new'
    # end
  end

 
  def update
    @user = current_user
    old_role = @user.role
    if @user.update_attributes(params[:user])
      if old_role == "guest" && !(@user.role? "guest")
          @user.activate_guest! 
          @user.save
          flash[:notice] = "Now a user"
          
      elsif (@user.role? "guest")
          flash[:notice] = "You are a guest"
      end
      redirect_to posts_path
    else
      render 'edit'
    end
  end

end
CODE
commit_state("User controller created and restful, controller uses current_user helper method, need to create that method. Create needs an eye as well as to clean at the top of the file with the before_filters")

generate :session, "user_session"
generate :nifty_scaffold, "user_session", "username:string", "password:string", "new", "destroy", "--skip-model", "--haml",
commit_state("generated user_session with a user_session controller combined with haml. Need to edit user_session controller to be restful.")
inside ('test') { 
  run "rm -rf fixtures functional integration"
}
commit_state("Removed fixtures, functional, integration for factories, shoulda and cucumber")

file "app/controllers/application_controller.rb", <<-CODE
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user, :current_user_session

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to posts_path
  end
  
  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user    
    @current_user ||= login_as_trial_user
  end

  def login_as_trial_user
    name = session[:session_id]
    @current_user = User.find_by_username(name) || 
                               User.create(
                               :username => name, 
                               :password => name, 
                               :password_confirmation => name, 
                               :role => "guest", 
                               :email => "change@this.com")
     UserSession.create(@current_user, true)
     @current_user_session = UserSession.find
     current_user
  end
  
  def current_ability
    Ability.new(current_user)
  end

   
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
CODE
commit_state("application_controller has now authentication helpers and filters passwords, current_user method added")

file "app/controllers/user_sessions_controller.rb", <<-CODE
class UserSessionsController < ApplicationController
    #before_filter :current_user_session, :only => [:destroy]
    load_and_authorize_resource

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to posts_path
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to posts_path
  end
  
end
CODE
commit_state("user_sessions_controller is now restful. UserSession.find for current user")

file "app/models/ability.rb", <<-CODE
class Ability 
  include CanCan::Ability
  
  # alias_action :index, :show, :to => :read
  # alias_action :new, :to => :create
  # alias_action :edit, :to => :update
  
  def initialize(user)
    if user.role? :admin
      can :manage, :all
    end
    
    if user.role? :moderator
      can :manage, :all
    end
    
    if user.role? :user
      can :read, :all
      can :create, :all
      can :destroy, :all do |obj_class, obj|
       obj.try(:user) == user 
       3.minutes.ago <= obj.created_at
     end
      can :update, :all do |obj_class, obj|
       obj.try(:user) == user 
       3.minutes.ago <= obj.created_at
      end
      can :destroy, UserSession do |us|
        user == us.try(:user)
      end
      cannot :create, UserSession
      cannot :create, User
      cannot :destroy, User
    end
    
    if user.role? :guest
      can :read, :all
      can :create, UserSession
      cannot :destroy, UserSession
      can :create, User
      can :update, User
    end
    
  end
end
CODE
commit_state("added app/models/ability.rb with the default User roles. Need to edit this to get it to work, both admin and moderator have full access, user can read, create and edit/destroy his own stuff during the time limit (3 minutes), guests can see everything **EDIT THIS**")


route "map.login   '/login',  :controller => :UserSessions,  :action => :new"
route "map.logout  '/logout', :controller => :UserSessions,  :action => :destroy"
route "map.signup  '/signup', :controller => :Users,    :action => :new"
commit_state("added /login, /logout, /signup routes with Users and UserSessions controllers")


rake "db:migrate"
commit_state("Database migration for User model and its updates - MIGRATION")

# jQuery
# jquery_filename = "jquery-1.3.2.min.js"
# jquery_dest = "public/javascripts/#{jquery_filename}"
# run "curl -L http://jqueryjs.googlecode.com/files/#{jquery_filename} > #{jquery_dest}"
# commit_state("Downloaded #{jquery_filename} and added to #{jquery_dest}")

file "public/javascripts/application.js", <<-CODE
jQuery(document).ready(function() {
	$('#---------CHANGE THIS----').submit(function() {
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		 return false;		
	})
	
	$("#stuff").sortable({

          update : function(event, ui)
          {
            var datas = $("#stuff").sortable('serialize');
            //datas is a string btw :-()
            $.post("posts/sort", {stuff : datas}, null, "script");
        }
      });
      
$(function() {
  $(".pagination a").live("click", function() {
    $(".pagination").html("Page is loading...");
    $.get(this.href, null, null, "script");
    return false;
  });
});

})

CODE

file "app/views/user_sessions/new.html.haml", <<-CODE
- title "New User Session"

- semantic_form_for(@user_session) do |f|
  = f.inputs :username, :password
  = f.commit_button 'Submit'
CODE
file "app/views/users/_form.html.haml", <<-CODE
- semantic_form_for(@user) do |f|
  - f.inputs do
    = f.input :username
    = f.input :password
    = f.input :password_confirmation, :label => 'Confirm your password'
    = f.input :email
    = f.input :role, :as => :radio, :collection => User::ROLES
  = f.buttons
CODE
commit_state("edited generated forms for User and UserSessions to use formtastic")

file "/public/banned.html", <<-CODE
"You have been banned BY MY RACK MIDDLEWARE BEOTCH, source at github"
CODE
file "lib/banhammer.rb", <<-CODE
class BanHammer
  def initialize(app)
    @app = app
  end
  
  def call(env)
    #if BannedIP.find_by_ip(env["REMOTE_ADDR"])
    if BannedIp.connection.execute("SELECT ip FROM bannedips" +" WHERE ip = %s" % env["REMOTE_ADDR"].to_s)
      file = "\#{RAILS_ROOT}/public/banned.html"
      [403, {"Content-Type" => "text/html" }, [File.read(file)]]
    else
      @status, @headers, @response = @app.call(env)
      [@status, @headers, self]
    end
  end
  
  def each(&block)
    @response.each(&block)
  end
end
CODE
commit_state("Added a H")
puts <<-CODE
************************************************"
App generation is all done now
There is alot to do though.

TO config/enviroment.rb
ADD 
  config.middleware.use ‘BanHammer’
AND
  Generate model BannedIP
AND
  Check the lib/banhammer.rb
  if BannedIp.connection.execute("SELECT ip FROM bannedips" + " WHERE ip = %s" % env["REMOTE_ADDR"].to_s)
  Decide if you want raw sql, or AR.

TO app/stylesheets/screen.sass
ADD
  // This import applies a global reset to any page that imports this stylesheet.
  @import blueprint/reset.sass
  // To configure blueprint, edit the partials/base.sass file.
  @import partials/base.sass
  // Import all the default blueprint modules so that we can access their mixins.
  @import blueprint
  // Import the non-default scaffolding module.
  @import blueprint/scaffolding.sass

  @import partials/skintastic.sass

TO app/stylesheets/partials/_skintastic.sass
ADD
  @import formtastic_base.sass

TO app/stylesheets/partials/_skintastic.sass
ADD
  form
    +stack-form

You also need to check up in the image model as well as the ability class.
images_controller needs to be altered to work as polymorphic with your other models
and add an index to the polymorphic migration.
Other then that, you are all set.
CODE

