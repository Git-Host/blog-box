require "dropbox_sdk"
require "mocha"

require File.expand_path("capybara_test_case", "test/support")
require File.expand_path("blog", "models")
require File.expand_path("post", "models")
require File.expand_path("view_helper", "lib")

class ProtectedAppTest < CapybaraTestCase
  def setup
    super
    # rack-test hack!
    page.driver.browser.authorize "admin", "admin"
  end
  
  def test_signing_in_without_an_authorized_dropbox_session
    DropboxSession.any_instance.expects(:authorized?).returns(false)
    DropboxSession.any_instance.expects(:serialize).returns(nil)
    DropboxSession.any_instance.expects(:get_authorize_url).with(DROPBOX_CALLBACK_URL).returns("/")
    
    visit "/protected/sign_in"
    assert_equal "/", current_path
  end
  
  def test_signing_in_with_an_authorized_dropbox_session
    DropboxSession.any_instance.expects(:authorized?).returns(true)
    visit "/protected/sign_in"
    
    assert_equal "/", current_path
    page.has_css?("div.alert-success", text: "Successfully signed in", visible: true)
  end
  
  def test_authorize
    access_token = stub(key: "access-key", secret: "access-secret")
    DropboxSession.any_instance.expects(:get_access_token).returns(access_token)
    DropboxSession.any_instance.expects(:set_access_token).with("access-key", "access-secret")
    DropboxSession.any_instance.expects(:serialize).returns(nil)
    
    visit "/protected/authorize?oauth_token=token"
    assert_equal "/", current_path
  end
  
  def test_sign_out
    post = Post.new(File.expand_path("first-test-post.md", "test/posts"))
    Blog.any_instance.expects(:find_post_by_filename).with("my-first-blog-post.html").returns(post)
    Blog.any_instance.expects(:render_post).with("my-first-blog-post.html").returns(post.to_html)
    Cuba.any_instance.expects(:logged_in?).at_least(2).returns(true)
    
    visit "/posts/my-first-blog-post.html"
    
    Blog.any_instance.expects(:render_post).returns("")
    click_button "Sign out"
    assert_equal "/", current_path
    page.has_css?("div.alert-success", text: "Successfully signed out", visible: true)
  end
  
  def test_publish
    Blog.any_instance.expects(:render_post).at_least(2).returns("")
    Cuba.any_instance.expects(:logged_in?).at_least(2).returns(true)
    
    visit "/"
    
    DropboxSession.any_instance.expects(:authorized?).returns(true)
    DropboxCLI.any_instance.expects(:fetch_posts).returns(nil)
    Blog.any_instance.expects(:publish_all_posts).returns(3)
    click_button "Publish"
    assert_equal "/", current_path
    page.has_css?("div.alert-success", text: "3 posts have been published.", visible: true)
  end
  
  def test_publishing_without_being_authorized
    Blog.any_instance.expects(:render_post).at_least(2).returns("")
    Cuba.any_instance.expects(:logged_in?).at_least(2).returns(true)
    
    visit "/"
    
    DropboxSession.any_instance.expects(:authorized?).twice.returns(false)
    DropboxSession.any_instance.expects(:serialize).returns(nil)
    DropboxSession.any_instance.expects(:get_authorize_url).with(DROPBOX_CALLBACK_URL).returns("/")
    click_button "Publish"
    assert_equal "/", current_path
  end
end