class EmailListSubscriber
  include SuckerPunch::Job

  def perform(email, list)
    puts "[WORKER][EmailListSubscriber]: Subscribing #{email} to #{list}..."

    gb = Gibbon::API.new ENV['MAILCHIMP_API_KEY']

    unless email_signups_enabled?
      puts "Not signing up #{email} for newsletter - email signups not enabled."
      return false
    end

    if list == "general_list" # Flag name duplicated in misc_controller
      relevant_mailchimp_list_id = ENV['MAILCHIMP_GENERAL_LIST_ID']
    elsif list == "launch_list" # Flag name duplicated in misc_controller
      relevant_mailchimp_list_id = ENV['MAILCHIMP_LAUNCH_LIST_ID']
    else
      raise "Invalid list subscribe"
    end

    begin
      gb.lists.subscribe({
        id:     relevant_mailchimp_list_id,
        email:  { email: email }
      })
    rescue Gibbon::MailChimpError => e
      if e.code == 214 # <email> is already subscribed to list....
        puts e.message
      elsif e.message.match /has been banned/i
        puts e.message
      else
        raise e
      end
    end

    puts "[WORKER][EmailListSubscriber]: Done...."
  end


  private

  def email_signups_enabled?
    Rails.env.production?
  end

end
