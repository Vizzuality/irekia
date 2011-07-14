class ModerationMailer < ActionMailer::Base
  default :from => "test@ferdev.com"

  def accepted(item)
    @item = item
    author = item.respond_to?(:users) ? item.users.first : item.user
    mail(
      :to => author.email,
      :subject => "Irekia - contenido aceptado"
    )
  end

end
