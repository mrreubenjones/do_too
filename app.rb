require "sinatra"
require "sinatra/reloader"
require "data_mapper"
use Rack::MethodOverride

set :port, 9999

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/app.db")

class Task
  include DataMapper::Resource

  property :id, Serial
  property :task, Text, :required => true
  property :complete, Boolean, :required => true, :default => 0
end

DataMapper.auto_upgrade!

get "/" do
  incomplete = Task.all(:complete => false)
  @todo = incomplete.count
  @complete = Task.all(:complete => true)
  @tasks = Task.all :order => :id.desc
  @title = "Your ToDo's, To Do."
  erb :home
end

post "/" do
  t = Task.new
  t.task = params[:task]
  t.save
  redirect '/'
end

delete '/:id' do
	t = Task.get params[:id]
	t.destroy
	redirect '/'
end

get '/:id/complete' do
	t = Task.get params[:id]
	t.complete = t.complete ? 0 : 1
	t.save
	redirect '/'
end

