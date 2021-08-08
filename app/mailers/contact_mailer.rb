
class ContactMailer < ApplicationMailer
  default from: 'noreply@stevendriggs.com'
  layout 'contact_mailer'

  before_action :set_contact

  def auto_reply
    mail(
      to: email_address_with_name(
        @contact[:email],
        @contact[:name]
      ),
      subject: "Thank you for reaching out, #{@contact[:name]}!",
    )
  end

  def contact_me
    mail(
      to: Rails.application.credentials.contact_email,
      subject: "Website Contact Request from #{@contact[:name]}",
      reply_to: email_address_with_name(
        @contact[:email],
        @contact[:name]
      ),
    )
  end

  private

  def set_contact
    @contact = params[:contact]
  end
end
