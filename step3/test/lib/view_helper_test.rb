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
    @obj.expects(:write).with("html")
    
    @obj._render("index", posts: "blah")
  end
  
  def test_user_is_logged_in
    @obj.expects(:_session).with(:dropbox_session).returns(false)
    refute @obj.logged_in?
    
    @obj.expects(:_session).with(:dropbox_session).returns(true)
    assert @obj.logged_in?
  end
  
  def test_renders_a_post
    Blog.any_instance.expects(:render_post).with("post.md").returns("my post")
    @obj.render_post(stub(filename: "post.md"))
  end
  
  def test_identifies_an_active_post
    @obj.stubs(request_path: "/")
    post = stub(filename: "post.md")
    assert @obj.active_post?(post, 0)
    refute @obj.active_post?(post, 1)
    
    @obj.stubs(request_path: "posts/post.md")
    assert @obj.active_post?(post, 1)
  end
end