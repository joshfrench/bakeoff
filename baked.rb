require 'sinatra/base'
require 'uri'
require 'entry'
require 'ballot'


class Baked < Sinatra::Base
  use Rack::MethodOverride
  use Rack::GridFS, :hostname => Mongoid.database.connection.primary_pool.host,
                    :port => Mongoid.database.connection.primary_pool.port,
                    :database => Mongoid.database.name, :prefix => 'gridfs'
  BSON::ObjectID = BSON::ObjectId

  get '/entries' do
    @entries = Entry.all
    haml :'entries/index'
  end

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
      @entries = Entry.all
      haml :'entries/index'
    end
  end

  delete "/entries/:id" do
    if entry = Entry.find(params[:id])
      entry.destroy
    end
    redirect "/entries"
  end

  get '/vote' do
    @entries = Entry.all
    @ballot = Ballot.find_or_initialize_by(:ip => request.ip)
    haml :'votes/new'
  end

  post '/vote' do
    @ballot = Ballot.find_or_create_by(:ip => request.ip)
    @ballot.from_hash(params[:ballot])
    @ballot.save
    redirect '/vote'
  end

  get '/results' do
    @overall = Ballot.overall
    @taste = Ballot.category(:taste)
    @creativity = Ballot.category(:creativity)
    haml :'results/index'
  end

  error Mongoid::Errors::DocumentNotFound do
    raise NotFound
  end
end
