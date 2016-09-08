ENV["RACK_ENV"] ||= "development"
require 'sinatra/base'
require_relative 'data_mapper_setup'
require 'sinatra/flash'


class Bookmark < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  helpers do
    def the_user
      @the_user ||= User.get(session[:id])
    end
  end

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/add-link' do
    link = Link.new(:title => params[:title], :url => params[:url])
    params[:tag].split(", ").each do |tag|
      link.tags << Tag.create(name: tag)
    end
    link.save
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.all(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/sign_up' do
    @user = User.new
    erb :'users/sign_up'
  end

  post '/welcome' do
    @user = User.new(email: params[:email],
              password: params[:password],
              password_confirmation: params[:password_confirmation])
    if @user.save
      session[:id] = @user.id
      redirect '/links'
    else
      flash.now[:error] = @user.errors.full_messages
      erb :'users/sign_up'
    end
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
