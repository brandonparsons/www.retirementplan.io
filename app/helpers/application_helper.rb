module ApplicationHelper

  def title(title)
    content_for (:title) { title }
  end

  def description(description)
    content_for (:description) { description }
  end

  # http://andre.arko.net/2013/02/02/nested-layouts-on-rails--31/
  def inside_layout(parent_layout)
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end

end
