require 'sinatra/base'
require 'partials'
require 'uri'
require 'entry'
require 'ballot'


class Baked < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/public'
  use Rack::MethodOverride
  helpers Sinatra::Partials

  get '/' do
    haml :index
  end

  get '/vote' do
    @ballot = Ballot.new
    @taste = @creativity = @presentation = Entry.all.sort
    haml :'votes/new'
  end

  post '/vote' do
    @ballot = Ballot.find_or_initialize_by_name(params[:ballot][:name])
    if @ballot.new_record?
      @ballot.from_hash(params[:ballot])
      @ballot.ip = request.ip
      if @ballot.save
        haml :'/votes/thanks'
      else
        @taste = @ballot.taste.map {|e| Entry.find(e)}
        @creativity = @ballot.creativity.map {|e| Entry.find(e)}
        @presentation = @ballot.presentation.map {|e| Entry.find(e)}
        haml :'votes/new'
      end
    else
      haml :'votes/dupe'
    end
  end

  get '/entries/new' do
    @entry = Entry.new
    haml :'entries/new'
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
    @presentation = Ballot.category(:presentation)
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

  get '/css/baked.css' do
    sass :baked
  end

  error Mongoid::Errors::DocumentNotFound do
    raise NotFound
  end

  error Mongo::GridFileNotFound do
    raise NotFound
  end
end
