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
    refute_nil posts.find { |post| post =~ /first-test-post/ }
    refute_nil posts.find { |post| post =~ /second-test-post/ }
  end
  
  def test_public_directory_exists
    assert Dir.exists?(@blog.public_directory)
  end
  
  def test_turns_md_posts_into_html_articles
    md_posts = @blog.find_all_posts
    @blog.publish_all_posts
    
    to_html(md_posts) do |html_articles|
      assert html_articles.all? { |html_article| File.exists?(html_article) }
    end
    FileUtils.rm_rf @blog.public_directory
  end
  
private

  def to_html(md_posts)
    html_posts = md_posts.inject([]) do |posts, post|
      extname = File.extname(post)
      basename = File.basename(post, extname)
      html_article = File.join(@blog.public_directory, "#{basename}.html")
      posts << html_article
    end
    yield html_posts
  end
end
