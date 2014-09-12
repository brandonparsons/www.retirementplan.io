class MiscController < ApplicationController
  protect_from_forgery except: [:error]

  def error
    raise "Test Error"
  end

  def mailing_list_subscribe
    email = params[:email]
    return missing_parameters unless email.present?
    return invalid_parameters unless email.match(/.+@.+\..+/i)

    EmailListSubscriber.new.async.perform(email) unless params[:name].present? # Name is a honeypot

    if request.xhr?
      render json: {success: true, message: 'Subscribed to mailing list'}
    else
      redirect_to root_path
    end
  end

  def complete_sign_in_tests
    # When signing up via the modal, we need to ensure that we complete ongoing
    # A/B tests. Posting via on-page javascript.
    xhr_only
    finish_signup_ab_tests
    render json: {status: :success, message: "Completion noted."}
  end


  private

  # Duplicated in RedirectController
  def finish_signup_ab_tests
    finished(:sign_up)
  end

end
