require 'sinatra/base'
require 'partials'
require 'uri'
require 'entry'
require 'ballot'

class Baked < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/public'
  set :haml, :format => :html5
  set :boot_time, Time.now

  configure :production do
    set :sass, :style => :compressed
    set :raise_errors, false
    set :show_exceptions, false
    use Rack::Auth::Basic do |username, password|
      [username, password] == [ENV['DP_USER'], ENV['DP_PASS']]
    end
  end

  CarrierWave.configure do |config|
    config.grid_fs_database = Mongoid.database.name
    config.storage = :grid_fs
    config.grid_fs_access_url = "/gridfs"
  end

  use Rack::MethodOverride
  helpers Sinatra::Partials

  get '/' do
    static_page
    haml :index
  end

  get '/vote' do
    not_found if ENV['POLLS_CLOSED']
    last_modified Entry.max(:updated_at)
    @ballot = Ballot.new
    @taste = @creativity = @presentation = Entry.all.sort
    haml :'votes/new'
  end

  post '/vote' do
    not_found if ENV['POLLS_CLOSED']
    @ballot = Ballot.find_or_initialize_by_name(params[:ballot][:name])
    if @ballot.new_record?
      @ballot.from_hash(params[:ballot])
      @ballot.ip = request.ip
      if @ballot.save
        redirect '/vote/thanks'
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

  get '/vote/thanks' do
    static_page
    haml :'/votes/thanks'
  end

  get '/entries/new' do
    static_page
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
    last_modified @entry.updated_at
    haml :'entries/show'
  end

  get '/results' do
    not_found unless ENV['POLLS_CLOSED']
    last_modified Ballot.max(:updated_at)
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
    last_modified file.upload_date
    headers 'Content-Length' => file.file_length.to_s
    file.read
  end

  get '/css/baked.css' do
    file = File.join(File.dirname(__FILE__), %w(views baked.sass))
    last_modified File.mtime(file)
    sass :baked
  end

  error Mongoid::Errors::DocumentNotFound do
    not_found
  end

  error Mongo::GridFileNotFound do
    not_found
  end

  not_found do
    static_page
    haml :'404'
  end

  error do
    static_page
    haml :'500'
  end

  def static_page
    cache_control :public, :max_age => 60 * 60
    etag options.boot_time.to_s
  end

end
