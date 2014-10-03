class MiscController < ApplicationController
  protect_from_forgery except: [:error]

  def error
    raise "Test Error"
  end

  def mailing_list_subscribe
    email = params[:email]
    return missing_parameters unless email.present?
    return invalid_parameters unless email.match(/.+@.+\..+/i)

    list  = params[:list] || "general_list"

    EmailListSubscriber.new.async.perform(email, list) unless params[:name].present? # Name is a honeypot

    if request.xhr?
      render json: {success: true, message: 'Subscribed to mailing list'}
    else
      redirect_to root_path
    end
  end

end
