class EmailListSubscriber
  include SuckerPunch::Job

  def perform(email)
    puts "[WORKER][EmailListSubscriber]: Subscribing #{email}....."
    gb = Gibbon::API.new ENV['MAILCHIMP_API_KEY']

    unless email_signups_enabled?
      puts "Not signing up #{email} for newsletter - email signups not enabled."
      return false
    end

    begin
      gb.lists.subscribe({
        id:     ENV['MAILCHIMP_GENERAL_LIST_ID'],
        email:  { email: email }
      })
    rescue Gibbon::MailChimpError => e
      if e.code == 214 # <email> is already subscribed to list....
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
