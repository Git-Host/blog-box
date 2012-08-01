require "minitest/autorun"
require "tempfile"
require "fileutils"
require "mocha"

require File.expand_path("dropbox_cli", "lib")

class DropboxCLITest < MiniTest::Unit::TestCase
  def test_posts_fetching_when_no_output_dir_exists
    client = DropboxCLI.new("blah")
    assert_nil client.fetch_posts("/does-not-exist")
  end
  
  def test_fetches_posts
    posts_dir = "posts"
    dropbox_client = mock_dropbox_client(posts_dir)
    Dir.stubs(:exists?).with(posts_dir).returns(true)
    
    posts_fetched = dropbox_client.fetch_posts(posts_dir)
    assert_equal 3, posts_fetched
  end
  
private

  def mock_dropbox_client(posts_dir)
    client = Object.new
    contents = (1..3).map { |i| {"path" => "file#{i}.md"} }
    client.expects(:metadata).with("/").returns({"contents" => contents})
    (1..3).each do |i|
      post = "file#{i}.md"
      client.expects(:get_file_and_metadata).with(post).returns([nil, i])
      File.stubs(:open).with(File.join(posts_dir, post), "w").returns(nil)
    end
    
    dropbox_client = DropboxCLI.new("blah")
    dropbox_client.stubs(:client).returns(client)
    dropbox_client
  end
end
