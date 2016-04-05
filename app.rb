require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  @db = SQLite3::Database.new('./database/barbershop.sqlite')
  @db.execute 'CREATE TABLE IF NOT EXISTS "users" 
  (
    "id" INTEGER PRIMARY KEY  NOT NULL ,
    "username" VARCHAR NOT NULL  DEFAULT (null) ,
    "phone" VARCHAR OT NULL ,
    "datestamp" VARCHAR NOT NULL ,
    "barber" VARCHAR NOT NULL ,
    "color" VARCHAR NOT NULL 
  )'
  @db.close
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/contacts' do
  erb :contacts
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]
  @error = []

  hash_errors = {
    :username => "Введите имя",
    :phone => "Введите телефон",
    :datetime => "Введите дату"
  }

  hash_errors.each {|key, value| @error << value if params[key] == ''}
  if @error.size!= 0
    return (erb :visit)
  end

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"
end

post '/contacts' do
  require 'pony'
  @email = params[:email]
  @message = params[:message]
  @error = []

  hash_errors = {
    :email => "Введите почту",
    :message => "Введите текст письма"
  }
  hash_errors.each {|key, value| @error << value if params[key] == ''}

  if @error.size!= 0
    return (erb :visit)
  end

  Pony.mail({
  :to => @email,
  :via => :smtp,
  :subject => "Отзыв barber",
  :body => @message,
  :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => '',
    :password             => '',
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
  }
})
  erb "OK, to mail #{@email} send message."
end