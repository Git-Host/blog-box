require "date"
require "rdiscount"

require File.expand_path("string_ext", "lib")
require File.expand_path("nil_class_ext", "lib")

class Post
  attr_accessor :created_on, :title, :text, :filename
  
  def initialize(post_file)
    lines = File.readlines(post_file)
    return unless lines.length > 3
    parse_created_on(lines.shift)
    parse_title(lines.shift)
    lines.shift if lines.first.blank?
    self.text = lines.join
  end
  
  def valid?
    created_on.present? && title.present? && text.present?
  end
  
  def to_html
    RDiscount.new(text).to_html
  end
  
private

  def parse_created_on(created_on)
    md = created_on.to_s.chomp.match(/(\d{4}-\d{2}-\d{2})\z/)
    if md
      match = md.captures.first
      begin
        Date.strptime match, "%Y-%m-%d"
        self.created_on = match
      rescue ArgumentError; end
    end
  end
  
  def parse_title(title)
    md = title.to_s.chomp.match(/\Atitle:\s*(.+)/i)
    if md
      self.title = md.captures.first
      self.filename = self.title.gsub(/\s+/, '-').gsub(/[^\w-]/, '').downcase + ".html"
    end
  end
end
