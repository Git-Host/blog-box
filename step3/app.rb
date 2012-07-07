require "cuba"
require "rack/protection"
require "rack/csrf"
require "rack-flash"
require "cuba/render"

require File.expand_path("protected_app")
require File.expand_path("view_helper", "lib")
require File.expand_path("blog", "models")

Cuba.use Rack::Static, urls: %w(/css /img /js), root: "public"
# expire session after 1 month
Cuba.use Rack::Session::Cookie, expire_after: 2592000, secret: "change-me"
Cuba.use Rack::Flash, flash_app_class: Cuba, sweep: true
Cuba.plugin Cuba::Render
Cuba.plugin ViewHelper

Cuba.define do
  on "protected" do
    run Protected
  end
  
  on get do
    on "posts/([\\w-]+?\\.html)" do |filename|
      post = Blog.new.find_post_by_filename(filename)
      
      if post
        _render "posts/show", post: post
      else
        res.redirect "/"
      end
    end
    
    on root do
      posts = Blog.new.find_all_posts
      _render "index", posts: posts
    end
  end
end