class Messenger
  def self.send_message(number, message, from_number: ENV.fetch('PHONE_NUMBER'))
    account_sid = ENV.fetch("TWILIO_ACCOUNT_SID")
    auth_token = ENV.fetch("TWILIO_AUTH_TOKEN")

    client = Twilio::REST::Client.new(account_sid, auth_token)

    message = client.messages.create(
      body: message,
      to: number,
      from: from_number)
  end
end
