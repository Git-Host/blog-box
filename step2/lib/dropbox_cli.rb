require "dropbox_sdk"

require File.expand_path("settings", "lib")

class DropboxCLI
  ACCESS_TYPE = :app_folder
  
  def initialize(settings = nil)
    @settings = settings || Settings.new
  end
  
  def login
    return if session.authorized?
    access_token = @settings["access_token"]
    if access_token
      session.set_access_token(access_token[:key], access_token[:secret])
      return
    else
      session.get_request_token
      session.get_authorize_url
    end
  end
  
  def access_token=(access_token)
    @settings["access_token"] = {key: access_token.key, secret: access_token.secret}
    login
  end
  
  def fetch_posts(dest)
    return unless Dir.exists?(dest)
    
    response = client.metadata("/")
    response["contents"].each do |file|
      path = file["path"]
      post_data, metadata = client.get_file_and_metadata(path)
      basename = File.basename(path)
      File.open(File.join(dest, basename), "w") do |post|
        post.puts(post_data)
      end
    end
    
    response["contents"].length
  end
  
private
  
  def session
    @session ||= DropboxSession.new(ENV["APP_KEY"], ENV["APP_SECRET"])
  end
      
  def client
    @client ||= DropboxClient.new(session, ACCESS_TYPE)
  end
end
