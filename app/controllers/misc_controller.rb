class MiscController < ApplicationController
  protect_from_forgery except: [:error]

  def error
    raise "Test Error"
  end

  def health
    render text: "OK"
  end

  def sitemap
    fresh_when last_modified: Post.last_post_date, public: true
  end

  def sign_in
    # Basically a no-op in case you want to track sign-ins in the future, and to
    # make URL consistent with sign_up.
    # This route will not be directly visited if signing in through the modal.
    redirect_to ENV['SIGN_IN_PATH']
  end

  def sign_up
    # This route will not be directly visited if signing up through the modal.
    finish_signup_ab_tests # Completes any signup A/B tests prior to forwarding on
    redirect_to ENV['SIGN_UP_PATH']
  end

  def complete_sign_in_tests
    # When signing up via the modal, we need to ensure that we complete ongoing
    # A/B tests. Posting via on-page javascript.
    xhr_only
    finish_signup_ab_tests
    render json: {status: :success, message: "Completion noted."}
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


  private

  def finish_signup_ab_tests
    finished("home_page_button_colour")
  end

end
