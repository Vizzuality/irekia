class Sharing < ActionMailer::Base
  default :from => "test@ferdev.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sharing.share_content.subject
  #
  def share_content(to, content)
    @greeting = "Hi"

    mail :to => to
  end
end
