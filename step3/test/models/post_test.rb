require "minitest/autorun"

require File.expand_path("post", "models")

class PostTest < MiniTest::Unit::TestCase
  def test_parses_a_valid_post
    post_file = File.expand_path("first-test-post.md", "test/posts")
    post = Post.new(post_file)
    
    assert post.valid?
    assert_equal "2012-06-10", post.created_on
    assert_equal "My first blog post!", post.title
    assert_equal "my-first-blog-post.html", post.filename
    assert_match post.text, /hello world/i
  end
  
  def test_parses_an_empty_post
    post_file = File.expand_path("empty-post.md", "test/posts")
    post = Post.new(post_file)
    
    refute post.valid?
    assert post.created_on.blank?
    assert post.title.blank?
    assert post.filename.blank?
    assert post.text.blank?
  end
  
  def test_parses_an_invalid_post
    post_file = File.expand_path("invalid-post.md", "test/posts")
    post = Post.new(post_file)
    
    refute post.valid?
    assert post.created_on.blank?
    assert post.title.blank?
    assert post.filename.blank?
    assert post.text.present?
  end
  
  def test_converts_text_to_html
    post_file = File.expand_path("first-test-post.md", "test/posts")
    post = Post.new(post_file)
    html = post.to_html
    
    assert_match html, /<h3>1st test post<\/h3>/
    assert_match html, /<strong>Hello world!<\/strong> - this is my first post/
  end
end