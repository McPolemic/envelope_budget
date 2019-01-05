class Messenger
  def self.send_message(number, message, from_number: nil, logger: nil)
    logger.info %("Sending message \"#{message}\" to #{number}") unless logger.nil?

    if Rails.env.production?
      from_number = ENV.fetch('PHONE_NUMBER')
      account_sid = ENV.fetch("TWILIO_ACCOUNT_SID")
      auth_token = ENV.fetch("TWILIO_AUTH_TOKEN")

      client = Twilio::REST::Client.new(account_sid, auth_token)
      message = client.messages.create(
        body: message,
        to: number,
        from: from_number)
    else
      @@last_message = message
    end
  end

  def self.last_message
    @@last_message
  end
end
