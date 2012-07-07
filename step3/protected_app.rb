require "dropbox_sdk"

require File.expand_path("blog", "models")
require File.expand_path("dropbox_cli", "lib")

DROPBOX_CALLBACK_URL = "http://localhost:9292/protected/authorize"

def callback_url
  ENV["DROPBOX_CALLBACK_URL"] || DROPBOX_CALLBACK_URL
end

def dropbox_session
  @dropbox_session ||= if session[:dropbox_session]
                         DropboxSession.deserialize(session[:dropbox_session])
                       else
                         DropboxSession.new(ENV["APP_KEY"], ENV["APP_SECRET"])
                       end
end

class Protected < Cuba; end

Protected.use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == ["admin", "admin"]
end

Protected.define do  
  on get do
    on "sign_in" do
      if dropbox_session.authorized?
        flash[:error] = "App already authorized to use Dropbox"
        res.redirect "/"
      else
        session[:dropbox_session] = dropbox_session.serialize
        res.redirect dropbox_session.get_authorize_url(callback_url)
      end
    end
    
    on "authorize", param("oauth_token") do |oauth_token|
      access_token = dropbox_session.get_access_token
      dropbox_session.set_access_token access_token.key, access_token.secret
      session[:dropbox_session] = dropbox_session.serialize
      flash[:notice] = "Successfully signed in"
      
      res.redirect "/"
    end
  end
  
  on post do
    on "sign_out" do
      session[:dropbox_session] = nil
      flash[:notice] = "Successfully signed out"
      res.redirect "/"
    end
    
    on "publish" do
      if dropbox_session.authorized?
        blog = Blog.new
        dropbox_client = DropboxCLI.new(dropbox_session)
        dropbox_client.fetch_posts(blog.posts_directory)
        published_post = blog.publish_all_posts
        flash[:notice] = "#{published_post} post#{'s' if published_post.zero? || published_post > 1 } #{published_post == 1 ? 'has' : 'have'} been published."
        res.redirect "/"
      else
        res.redirect "/protected/sign_in"
      end
    end
  end
end