class RedirectController < ApplicationController

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


  private

  # Duplicated in MiscController
  def finish_signup_ab_tests
    finished(:sign_up)
  end

end
