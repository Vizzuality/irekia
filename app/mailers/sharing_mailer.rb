class SharingMailer < ActionMailer::Base
  default :from => "test@ferdev.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sharing_mailer.share_content.subject
  #
  def share_content(from, to, url, message)
    @from_name = from.name
    @content_link = url
    @content_text = message

    I18n.with_locale from.locale do
      mail(
        :to => to.email,
        :subject => "#{from.name} quiere compartir este contenido de Irekia contigo"
      )
    end
  end
end
