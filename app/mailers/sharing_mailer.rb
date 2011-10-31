class SharingMailer < ActionMailer::Base
  default :from => "test@ferdev.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sharing_mailer.share_content.subject
  #
  def share_content(from, to, content)
    @from_name = from.name
    @content_text = content.email_share_message
    @content_link = url_for(content)

    I18n.with_locale from.locale do
      mail(
        :to => to,
        :subject => "#{from.name} quiere compartir este contenido de Irekia contigo"
      )
    end
    mail :to => to
  end
end
