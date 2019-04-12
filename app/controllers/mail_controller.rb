class MailController < ApplicationController
  def create
    logger.info "Email received: #{params[:subject]}"
    logger.info "Email received to: #{params[:to]"}"
    logger.info "Email received from: #{params[:from]"}"
    logger.info "Email body: #{params[:text]"}"

    head :ok
  end
end
