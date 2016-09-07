require 'sinatra/base'
require_relative 'data_mapper_setup'
require 'database_cleaner'

ENV["RACK_ENV"] ||= "development"

class Bookmark < Sinatra::Base

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
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/clean' do
    DatabaseCleaner.clean_with(:truncation)
    redirect '/links'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
