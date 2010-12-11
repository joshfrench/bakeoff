require 'sinatra/base'
require 'uri'
require 'entry'
require 'ballot'


class Baked < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/public'
  use Rack::MethodOverride

  get '/entries/new' do
    haml :'entries/new'
  end

  get "/entries/:id" do
    @entry = Entry.find(params[:id])
    haml :'entries/show'
  end

  post '/entries' do
    @entry = Entry.new(params[:entry])
    if @entry.save
      redirect "/entries/#{@entry.id}"
    else
      haml :'entries/new'
    end
  end

  get "/entries/:id" do
    @entry = Entry.find(params[:id])
    haml :'entries/show'
  end

  get '/results' do
    @overall = Ballot.overall
    @taste = Ballot.category(:taste)
    @creativity = Ballot.category(:creativity)
    haml :'results/index'
  end

  get '/gridfs/:id/:filename' do
    img = params[:id] + '/' + params[:filename]
    fs = Mongo::GridFileSystem.new(Mongoid.database)
    file = fs.open(img, 'r')
    content_type file.content_type
    headers 'Content-Length' => file.file_length.to_s
    file.read
  end

  error Mongoid::Errors::DocumentNotFound do
    raise NotFound
  end

  error Mongo::GridFileNotFound do
    raise NotFound
  end
end
