require "minitest/autorun"
require "tempfile"
require "fileutils"
require "mocha"

require File.expand_path("dropbox_cli", "lib")

class DropboxCLITest < MiniTest::Unit::TestCase
  def test_fetchs_posts_but_the_output_dir_does_not_exist
    client = DropboxCLI.new("blah")
    assert_nil client.fetch_posts("/zzz")
  end
  
  def test_fetchs_posts
    client = Object.new
    contents = (1..3).map { |i| {"path" => "file#{i}.md"} }
    client.expects(:metadata).with("/").returns({"contents" => contents})
    dest = "zzz"
    (1..3).each do |i|
      post = "file#{i}.md"
      client.expects(:get_file_and_metadata).with(post).returns([nil, i])
      File.expects(:open).with(File.join(dest, post), "w")
    end
    
    dropbox_client = DropboxCLI.new("blah")
    dropbox_client.stubs(:client).returns(client)
    Dir.expects(:exists?).with(dest).returns(true)
    posts_fetched = dropbox_client.fetch_posts(dest)
    assert_equal 3, posts_fetched
  end
end