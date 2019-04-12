class MailController < ApplicationController
  def create
    logger.info "Email received: #{params}"

    head :ok
  end
end
