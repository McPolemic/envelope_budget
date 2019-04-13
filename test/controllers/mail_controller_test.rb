require 'test_helper'
class MailControllerTest < ActionDispatch::IntegrationTest
  test "receiving an email returns a 200" do
    params = {
      to: 'budget@example.com',
      from: 'cassie@example.com',
      subject: 'Your Order From Groupon',
      text: 'You had an order. It was good.'
    }

    post mail_url, params: params

    assert response.ok?
  end
end

