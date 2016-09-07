ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require 'sinatra/flash'
require_relative 'data_mapper_setup'
require 'bcrypt'


class Bookmark < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  helpers do
   def current_user
     @current_user ||= User.get(session[:user_id])
   end
  end

  get '/' do
    'Hello Bookmark!'
  end

  get '/users/new' do
    @user = User.new
    erb(:'users/new')
  end

  post '/users' do
    @user = User.create(name: params[:name],
                        email: params[:email],
                        password: params[:password],
                        password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "User is successfully registered"
      redirect('/links')
    else
      flash.now[:errors] = @user.errors.full_messages      
      erb :'users/new'
    end
  end

  get '/links' do
    @links = Link.all
    erb(:'links/index')
  end

  get '/links/new' do
    erb(:'links/new')
  end

  post '/links/created' do
    link = Link.create(title: params[:title], url: params[:url])
    params[:tags].split(",").each do |tag|
      final_tag = Tag.first_or_create(name: tag.strip)
      link.tags << final_tag
    end
    link.save
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = (tag ? tag.links : [])
    erb(:'links/index')
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
