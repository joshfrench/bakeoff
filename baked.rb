require 'sinatra/base'
require 'uri'
require './lib/entry'
require './lib/ballot'


class Baked < Sinatra::Base
  use Rack::MethodOverride

  get '/entries' do
    @entries = Entry.all
    haml :'entries/index'
  end

  post '/entries' do
    @entry = Entry.new(params[:entry])
    if @entry.save
      redirect '/entries'
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
    @ballot = Ballot.new
    haml :'votes/new'
  end

  post '/vote' do
    @ballot = Ballot.from_hash(params[:ballot])
    @ballot.save
    "Thanks!"
  end
end
