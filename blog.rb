require "rubygems"
require "sinatra"
require "haml"
require "dm-core"
require "dm-timestamps"
require "do_postgres"

DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3:db.sqlite3")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :created_at, DateTime
  property :title, String, :length => 255
  property :body, Text
end

Post.auto_migrate!

get "/" do
  @posts = Post.all(:order => [:created_at.desc])
  haml :index
end

get "/post/new" do
  haml :new_post
end

post "/post/new" do
  Post.create(params)
  redirect "/"
end
