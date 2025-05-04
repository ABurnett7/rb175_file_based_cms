require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubi"

configure do 
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end

root = File.expand_path("..", __FILE__)

get "/" do
  @status = params[:status] ? params[:status] : nil

  @files = Dir.glob(root + "/data/*").map do |path|
    File.basename(path)
  end

  erb :index
end

get "/:filename" do
  file_path = root + "/data/" + params[:filename]
  
  if File.exist?(file_path)
    headers["Content-Type"] = "text/plain"
    File.read(file_path)
  else
    session[:message] = "#{params[:filename]} does not exist"
    redirect "/"
  end
end