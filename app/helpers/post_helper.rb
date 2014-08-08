module PostHelper

  def reading_time(input)
    time = ReadingTime.new.reading_time(input).to_f.round(0)
    time < 2 ? "Less than 2 minute read" : "#{time} minute read"
  end

  def blog_image(image_name)
    "/images/blog/#{image_name}"
  end

end
