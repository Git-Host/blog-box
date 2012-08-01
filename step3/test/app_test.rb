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
    stub_existing_blog_post
    visit "/posts/my-first-blog-post.html"
    
    assert_equal "/posts/my-first-blog-post.html", current_path
    assert page.has_selector?("h3")
    assert page.has_content?("1st test post")
  end
  
  def test_visits_a_nonexistent_post
    visit "/posts/fake-post.html"
    
    assert_equal "/", current_path
    page.has_css?("div.alert-error", text: "Post not found.", visible: true)
  end
  
private

  def stub_existing_blog_post
    post = Post.new(File.expand_path("first-test-post.md", "test/posts"))
    Blog.any_instance.stubs(find_post_by_filename: post)
    Blog.any_instance.stubs(render_post: post.to_html)
  end
end