module BlogHelper

  def blog_post?
    controller_name == 'blog' && action_name == 'show'
  end

  def blog_image(image_name)
    "/images/blog/#{image_name}"
  end

end
