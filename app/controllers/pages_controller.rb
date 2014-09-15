require 'rss' # For parsing RSS feed in sitemap

class PagesController < ApplicationController
  layout :resolve_layout

  def health
    render text: "OK"
  end

  def home;end
  def about;end
  def asset_allocation;end
  def retirement_planning;end
  def instant_notification;end
  def security;end
  def tour;end
  def disclosures;end
  def privacy;end
  def terms;end

  def sitemap
    expires_in 1.hour, public: true
  end


  private

  def resolve_layout
    action_name == 'home' ? 'application' : 'static'
  end

end
