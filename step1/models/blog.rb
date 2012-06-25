require "rdiscount"

class Blog
  attr_reader :posts_directory, :public_directory

  def initialize(posts_directory)
    @posts_directory = posts_directory
    Dir.mkdir(posts_directory) unless Dir.exists?(posts_directory)
    directory = File.dirname(posts_directory)
    @public_directory = File.join(directory, "public")
    Dir.mkdir(@public_directory) unless Dir.exists?(@public_directory)
  end
  
  def find_all_posts
    Dir.glob File.join(@posts_directory, "*.md")
  end
  
  def publish_all_posts
    posts = find_all_posts
    
    posts.each do |post|
      markdown = RDiscount.new(File.read(post))
      extname = File.extname(post)
      basename = File.basename(post, extname)
      html_article = File.join(@public_directory, "#{basename}.html")
      
      File.open(html_article, "w") do |f|
        f << markdown.to_html
      end
    end
  end
end
