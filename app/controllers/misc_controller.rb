class MiscController < ApplicationController
  def error
    raise "Test Error"
  end

  def health
    render text: "OK"
  end

  def sitemap
    fresh_when last_modified: Post.last_post_date, public: true
  end

end
