## Introducing blog-box: your very own [Markdown](http://daringfireball.net/projects/markdown/) and [Dropbox](http://www.dropbox.com/) powered blog engine ##

### What are we going to build? ###
Basically we are going to build a [Calepin](http://www.cristianrasch.com.ar/publish-your-very-own-blog-on-the-cheap-with-calepin.html) clone. Say what? No worries, thing is, I'd like to share the experience of building a small piece of software with a global audience going step by step through the process using a test-first approach.

### OK gotcha, but why? ###
Well, in the first place, to help spread the love for [Test-driven development](http://en.wikipedia.org/wiki/Test-driven_development) and also to share and discuss some good OOP (Object Oriented Programming) techniques.

Between us? Because Calepin is a proprietary product and they may charge us to use their platform in the future. Let's not take chances and build our own free and open source service, yey!

### First things first, our final product :P ###
The aim of these blog post series is to build a portable *blog engine*, which you may deploy to any hosting environment capable of running [Rack](http://rack.github.com/) applications. Here's a quick list of the ingredients that we'll need for this recipe:

* [Cuba](http://cuba.is/) - our beloved Ruby micro web framework of choice :)
* The official [dropbox-sdk](https://www.dropbox.com/developers/start/setup#ruby) gem
* [Rdiscount](https://github.com/rtomayko/rdiscount) - a Ruby library for parsing Markdown text and generating HTML documents

### What about our test-first approach? ###
Oops, got me. We'll be using the [minitest/unit](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/minitest/unit/rdoc/index.html) framework that ships with the Ruby standard library and the [Capybara](https://github.com/jnicklas/capybara) gem for integration testing.

### Sounds fun? ###
Well, it should :) - stay tuned for our first steps, see ya!
