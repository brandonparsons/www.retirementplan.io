class PagesController < ApplicationController
  layout :resolve_layout

  def home;end

  def about;end

  def disclosures;end

  def privacy;end

  def terms;end

  private

  def resolve_layout
    case action_name
    when "home"
      "application"
    else
      "static"
    end
  end

end
