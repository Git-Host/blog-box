require File.expand_path("post", "models")

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
    post_files = Dir.glob(File.join(@posts_directory, "*.md"))
    posts = post_files.map { |post_file| Post.new(post_file)  }
    posts.select(&:valid?)
  end
  
  def publish_all_posts
    find_all_posts.each do |post|
      html_article = File.join(@public_directory, post.filename)
      
      File.open(html_article, "w") do |f|
        f << post.to_html
      end
    end
  end
end
