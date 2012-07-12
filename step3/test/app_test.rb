require "mocha"

require File.expand_path("capybara_test_case", "test/support")
require File.expand_path("blog", "models")
require File.expand_path("post", "models")

class AppTest < CapybaraTestCase
  def test_root
    visit "/"
    
    assert_equal "/", current_path
    assert page.has_content?("blog-box, by @cristianrasch")
  end
  
  def test_a_particular_post
    mock_blog_instance_methods
    visit "/posts/my-first-blog-post.html"
    
    assert_equal "/posts/my-first-blog-post.html", current_path
    assert page.has_selector?("h3")
    assert page.has_content?("1st test post")
  end
  
  def test_a_nonexistent_post
    visit "/posts/fake-post.html"
    
    assert_equal "/", current_path
    page.has_css?("div.alert-error", text: "Post not found.", visible: true)
  end
  
private

  def mock_blog_instance_methods
    post = Post.new(File.expand_path("first-test-post.md", "test/posts"))
    Blog.any_instance.expects(:find_post_by_filename).with("my-first-blog-post.html").returns(post)
    Blog.any_instance.expects(:render_post).with("my-first-blog-post.html").returns(post.to_html)
  end
end