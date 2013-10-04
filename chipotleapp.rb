require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'time'

get '/' do
  # Retrieve from mongo the time_since_chipotle.
  if !get_all_times.to_a.empty?
    last_time_at_chipotle = get_all_times.to_a[0]["datetime"]
  else
    last_time_at_chipotle = nil
  end

  # Get now.
  now = Date.now

  # Calculate difference in time.
  unless last_time_at_chipotle.nil?
    @time_since_chipotle = (now - last_time_at_chipotle).to_i
  else
    @time_since_chipotle = -1
  end

  # Pass time_since_chipotle to front-end.
	erb :index
end

post '/sms/?' do
  # Receiving this text should update the Mongo.
  new_time_at_chipotle = {"datetime" => Date.now}

  # Update mongo record.
  set_time(new_time_at_chipotle)

  erb :index
end

####################################
# Accessing database
# ####################################
require 'mongo'
require 'uri'

def get_connection
  return @db_connection if @db_connection
  db = URI.parse(ENV['MONGOHQ_URL'])
  db_name = db.path.gsub(/^\//, '')
  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
  @db_connection
end

# include Mongo
# def get_connection
#   mongo_client = MongoClient.new
#   return mongo_client.db("db")
# end

# Create
def add_time(doc)
  db = get_connection
  coll = db.collection("last_time_since_chipotle")
  id = coll.insert(doc)
end

# Read all.
def get_all_times
  db = get_connection
  coll = db.collection("last_time_since_chipotle")
  return coll.find
end

# Update.
def set_time(doc)
  db = get_connection
  coll = db.collection("last_time_since_chipotle")
  coll.update({"datetime" => "datetime"}, doc)
end

# Delete all.
def delete_all_times
  db = get_connection
  coll = db.collection("last_time_since_chipotle")
  coll.remove
end