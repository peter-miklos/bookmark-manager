require 'sinatra/base'
require_relative 'data_mapper_setup'

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
  tag = Tag.first_or_create(:name => params[:tag])
  link.tags << tag
  link.save
  redirect '/links'
end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
