require "minitest/autorun"
require "tempfile"
require "fileutils"
require "mocha"

require File.expand_path("dropbox_cli", "lib")

class DropboxCLITest < MiniTest::Unit::TestCase
  def test_login_when_authorized
    DropboxSession.any_instance.stubs(:authorized?).returns(true)
    client = DropboxCLI.new
    assert_nil client.login
  end
  
  def test_login_witout_an_access_token
    settings = stub(:[] => nil)
    client = DropboxCLI.new(settings)
    
    session = Object.new
    session.expects(:authorized?).returns(false)
    session.expects(:get_request_token)
    session.expects(:get_authorize_url).returns("http://www.dropbox.com")
    client.stubs(:session).returns(session)
    
    assert_equal "http://www.dropbox.com", client.login
  end
  
  def test_login_with_an_access_token
    settings = stub(:[] => {key: "access key", secret: "access secret"})
    client = DropboxCLI.new(settings)
    
    session = Object.new
    session.expects(:authorized?).returns(false)
    session.expects(:set_access_token).with("access key", "access secret")
    client.stubs(:session).returns(session)
    
    assert_nil client.login
  end
  
  def test_fetchs_posts_but_the_output_dir_does_not_exist
    client = DropboxCLI.new
    assert_nil client.fetch_posts("/zzz")
  end
  
  def test_fetchs_posts
    cli = Object.new
    contents = (1..3).map { |i| {"path" => "file#{i}.md"} }
    cli.expects(:metadata).with("/").returns({"contents" => contents})
    dest = "zzz"
    (1..3).each do |i|
      post = "file#{i}.md"
      cli.expects(:get_file_and_metadata).with(post).returns([nil, i])
      File.expects(:open).with(File.join(dest, post), "w")
    end
    
    client = DropboxCLI.new
    client.stubs(:client).returns(cli)
    Dir.expects(:exists?).with(dest).returns(true)
    posts_fetched = client.fetch_posts(dest)
    assert_equal 3, posts_fetched
  end
  
  def test_sets_the_access_token
    settings = Object.new
    settings.expects(:[]=).with("access_token", {key: "access key", secret: "access secret"})
    client = DropboxCLI.new(settings)
    client.stubs(:login)
    client.access_token = stub(key: "access key", secret: "access secret")
  end
end