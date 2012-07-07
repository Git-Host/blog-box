require File.expand_path("blog", "models")

module ViewHelper
  def _render(view, locals = {})
    body = render("views/#{view}.erb", locals)
    unless locals[:posts]
      posts = Blog.new.find_all_posts
      locals.merge!(posts: posts)
    end
    write render("views/layouts/application.erb", locals.merge!(body: body))
  end
  
  def logged_in?
    !!_session(:dropbox_session)
  end
  
  def render_post(post)
    Blog.new.render_post(post.filename)
  end
  
  def active_post?(post, i)
    return true if request_path == "/" && i.zero?
    request_path =~ /#{post.filename}$/i
  end

private

  def write(html)
    res.write html
  end
  
  def _session(key)
    session[key]
  end
  
  def request_path
    @request_path ||= env["REQUEST_PATH"]
  end
end