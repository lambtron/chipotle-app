require 'rubygems'
require 'bundler/setup'
require 'sinatra'
get '/' do
	erb :index
end
post "/SMS" do
  params[:Body]
end
####################################
# Accessing database
# ####################################
# require 'mongo'
# require 'uri'

# def get_connection
#   return @db_connection if @db_connection
#   db = URI.parse(ENV['MONGOHQ_URL'])
#   db_name = db.path.gsub(/^\//, '')
#   @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
#   @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
#   @db_connection
# end

# include Mongo
# def get_connection
#   mongo_client = MongoClient.new
#   return mongo_client.db("db")
# end
# Create
def add_time(doc)
  db = get_connection
  coll = db.collection("time_since_chipotle")
  id = coll.insert(doc)
end
# Read.
def get_time(doc)
  db = get_connection
  coll = db.collection("time_since_chipotle")
  return coll.find
end
# Update.
def set_time(doc)
  db = get_connection
  coll = db.collection("time_since_chipotle")
  coll.update({"id" => doc["id"]}, doc)
end
# Delete.
def delete_time(doc)
  db = get_connection
  coll = db.collection("time_since_chipotle")
  coll.remove("id" => doc["id"])
end
# Things to do
	# parse inbound SMS
	# insert, update time_since_chipotle
	# upon refresh, calculate difference between now and time_since_chipotle, show that onto website
	#when reset, send text message to people on the subscriber list