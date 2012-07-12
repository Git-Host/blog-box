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
    mock_unauthorized_dropbox_session
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
    mock_dropbox_session_authorization
    visit "/protected/authorize?oauth_token=token"
    
    assert_equal "/", current_path
  end
  
  def test_sign_out
    mock_post_page
    visit "/posts/my-first-blog-post.html"
    
    # this one is called once we are redirected back to /
    Blog.any_instance.stubs(render_post: "")
    click_button "Sign out"
    assert_equal "/", current_path
    page.has_css?("div.alert-success", text: "Successfully signed out", visible: true)
  end
  
  def test_publish
    stub_post_page
    visit "/"
    
    mock_publishing_posts
    click_button "Publish"
    
    assert_equal "/", current_path
    page.has_css?("div.alert-success", text: "3 posts have been published.", visible: true)
  end
  
  def test_publishing_without_being_authorized
    stub_post_page
    visit "/"
    
    mock_unauthorized_dropbox_session
    click_button "Publish"
    
    assert_equal "/", current_path
  end
  
private

  def mock_unauthorized_dropbox_session
    DropboxSession.any_instance.expects(:authorized?).at_least(1).returns(false)
    DropboxSession.any_instance.stubs(serialize: nil)
    DropboxSession.any_instance.expects(:get_authorize_url).with(DROPBOX_CALLBACK_URL).returns("/")
  end
  
  def mock_dropbox_session_authorization
    access_token = stub(key: "access-key", secret: "access-secret")
    DropboxSession.any_instance.expects(:get_access_token).returns(access_token)
    DropboxSession.any_instance.expects(:set_access_token).with("access-key", "access-secret")
    DropboxSession.any_instance.stubs(serialize: nil)
  end
  
  def mock_post_page
    post = Post.new(File.expand_path("first-test-post.md", "test/posts"))
    Blog.any_instance.expects(:find_post_by_filename).with("my-first-blog-post.html").returns(post)
    Blog.any_instance.expects(:render_post).with("my-first-blog-post.html").returns(post.to_html)
    Cuba.any_instance.expects(:logged_in?).at_least(2).returns(true)
  end
  
  def stub_post_page
    Blog.any_instance.stubs(render_post: "")
    Cuba.any_instance.stubs(logged_in?: true)
  end
  
  def mock_publishing_posts
    DropboxSession.any_instance.expects(:authorized?).returns(true)
    DropboxCLI.any_instance.stubs(fetch_posts: nil)
    Blog.any_instance.expects(:publish_all_posts).returns(3)
  end
end