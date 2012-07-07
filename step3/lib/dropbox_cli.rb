class DropboxCLI
  ACCESS_TYPE = :app_folder
  
  def initialize(session)
    @session = session
  end
  
  def fetch_posts(dest)
    return unless Dir.exists?(dest)
    
    response = client.metadata("/")
    response["contents"].each do |file|
      path = file["path"]
      post_data, metadata = client.get_file_and_metadata(path)
      basename = File.basename(path)
      File.open(File.join(dest, basename), "w") do |post|
        post.puts(post_data)
      end
    end
    
    response["contents"].length
  end
  
private
  
  def client
    @client ||= DropboxClient.new(@session, ACCESS_TYPE)
  end
end
