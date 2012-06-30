require "minitest/autorun"
require "fileutils"

require File.expand_path("blog", "models")

class BlogTest < MiniTest::Unit::TestCase
  def setup
    @blog = Blog.new(File.expand_path("posts", "test"))
  end  
  
  def test_posts_directory_exists
    assert Dir.exists?(@blog.posts_directory)
  end

  def test_lists_all_available_posts
    posts = @blog.find_all_posts
    assert_equal 2, posts.length
    refute_nil posts.find { |post| post.filename == "my-first-blog-post.html" }
    refute_nil posts.find { |post| post.filename == "my-second-blog-post.html" }
  end
  
  def test_public_directory_exists
    assert Dir.exists?(@blog.public_directory)
  end
  
  def test_turns_md_posts_into_html_articles
    @blog.publish_all_posts
    
    ["my-first-blog-post", "my-second-blog-post"].each do |post|
      html_article = File.join(@blog.public_directory, "#{post}.html")
      assert File.exists?(html_article)
    end
    FileUtils.rm_rf @blog.public_directory
  end
end
