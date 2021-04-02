class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail to: Rails.application.credentials.gmail[:address], title: '【お問い合わせ】' + @contact.title
  end
end
