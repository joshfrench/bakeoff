require 'sinatra/base'
require 'partials'
require 'uri'

class Baked < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/public'
  set :haml, :format => :html5
  set :boot_time, Time.now

  configure :development do
    Mongoid.database = Mongo::Connection.new('localhost', Mongo::Connection::DEFAULT_PORT).db('bakeoff')
  end

  configure :production do
    require 'uri'
    mongo_uri = URI.parse(ENV['MONGOHQ_URL'])
    ENV['MONGOID_HOST'] = mongo_uri.host
    ENV['MONGOID_PORT'] = mongo_uri.port.to_s
    ENV['MONGOID_USERNAME'] = mongo_uri.user
    ENV['MONGOID_PASSWORD'] = mongo_uri.password
    ENV['MONGOID_DATABASE'] = mongo_uri.path.gsub("/", "")
    Mongoid.database = Mongo::Connection.new(ENV['MONGOID_HOST'], ENV['MONGOID_PORT']).db(ENV['MONGOID_DATABASE'])
    Mongoid.database.authenticate(ENV['MONGOID_USERNAME'], ENV['MONGOID_PASSWORD'])

    use Rack::Auth::Basic do |username, password|
      [username, password] == [ENV['DP_USER'], ENV['DP_PASS']]
    end

    set :sass, :style => :compressed
    set :raise_errors, false
    set :show_exceptions, false
  end

  CarrierWave.configure do |config|
    config.grid_fs_database = Mongoid.database.name
    config.storage = :grid_fs
    config.grid_fs_access_url = "/gridfs"
    if ENV['MONGOHQ_URL']
      config.grid_fs_host = ENV['MONGOID_HOST']
      config.grid_fs_port = ENV['MONGOID_PORT']
      config.grid_fs_username = ENV['MONGOID_USERNAME']
      config.grid_fs_password = ENV['MONGOID_PASSWORD']
    end
  end

  use Rack::MethodOverride
  helpers Sinatra::Partials

  require 'entry'
  require 'ballot'

  get '/' do
    static_page
    haml :index
  end

  get '/vote' do
    not_found unless polls_open?
    last_modified Entry.max(:updated_at)
    @ballot = Ballot.new
    @taste = @creativity = @presentation = Entry.all.sort
    haml :'votes/new'
  end

  post '/vote' do
    not_found unless polls_open?
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

  get '/entries/entries.js' do
    coffee :'entries/entries'
  end

  get "/entries/:id" do
    @entry = Entry.find(params[:id])
    last_modified @entry.updated_at
    haml :'entries/show'
  end

  get '/results' do
    not_found if polls_open?
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

  def development?
    options.environment == :development
  end

  def polls_open?
    development? or ENV['POLLS_CLOSED'].nil?
  end

end
