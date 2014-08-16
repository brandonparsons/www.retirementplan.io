class EmailListSubscriber
  include SuckerPunch::Job

  def perform(email)
    puts "[WORKER][EmailListSubscriber]: Subscribing #{email}....."
    gb = Gibbon::API.new ENV['MAILCHIMP_API_KEY']

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
end
