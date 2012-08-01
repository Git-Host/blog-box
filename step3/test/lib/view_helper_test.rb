require "minitest/autorun"
require "mocha"

require File.expand_path("view_helper", "lib")

class ViewHelperTest < MiniTest::Unit::TestCase
  def setup
    @obj = Object.new
    @obj.extend ViewHelper
  end
  
  def test_renders_a_partial
    @obj.expects(:render).with("views/index.erb", {posts: "blah"}).returns("index")
    @obj.expects(:render).with("views/layouts/application.erb", {posts: "blah", body: "index"}).returns("html")
    @obj.stubs(write: "html")
    
    @obj._render("index", posts: "blah")
  end
  
  def test_user_is_logged_in
    @obj.expects(:_session).with(:dropbox_session).returns(false)
    refute @obj.logged_in?
    
    @obj.expects(:_session).with(:dropbox_session).returns(true)
    assert @obj.logged_in?
  end
  
  def test_renders_a_post
    post, html = "post.md", "<h1>Blog post</h1>"
    Blog.any_instance.expects(:render_post).with(post).returns(html)
    assert_equal html, @obj.render_post(stub(filename: post))
  end
  
  def test_identifies_an_active_post
    post = stub(filename: "post.md")
    
    @obj.stubs(request_path: "/")
    assert @obj.active_post?(post, 0)
    refute @obj.active_post?(post, 1)
    
    @obj.stubs(request_path: "posts/post.md")
    assert @obj.active_post?(post, 1)
  end
end