# encoding: utf-8

class Tmailer < ActionMailer::Base
  default :from => "from@example.com"
  layout 'mail'

  def test_emails(to)
    Tmailer.deliver_welcome(to)
    Tmailer.deliver_comment(to)
    Tmailer.deliver_reset_password(to)
    Tmailer.deliver_new_question(to)
    Tmailer.deliver_new_follower(to)
    Tmailer.deliver_deleted_account(to)
    Tmailer.deliver_comment_approved(to)
    Tmailer.deliver_question_answered(to)
    Tmailer.deliver_content_rejected(to)
  end

  def welcome(to)
    @title = "Bienvenido a Irekia, Javier :-)"
    @subject = @title
    @text = "Gracias por registrarte en Irekia. ¡Ya puedes empezar a participar!"
    @show_notifications_link = false
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def comment(to)
    @title = "Tu comentario ha sido aprobado :-)"
    @subject = @title
    @text = "El comentario que dejaste ayer en la noticia 'Carril bici en Getxo' ha sido aprobado."
    @show_notifications_link = true
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def reset_password(to)
    @title = "¿No te acuerdas de tu contraseña?"
    @subject = @title
    @text = "Simplemente pulsa el enlace “Regenerar contraseña”. Irekia te pedirá a continuación el nuevo valor."
    @show_notifications_link = false
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def new_question(to)
    @title = "Nueva pregunta en Irekia"
    @subject = @title
    @text = "Ramón Iratxi Pérez te hace la siguiente pregunta:"
    @show_notifications_link = false
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def new_follower(to)
    @title = "¡Un nuevo seguidor! :-)"
    @subject = @title
    @text = "Ramón Iratxi Pérez ha comenzado a seguirte en Irekia. ¿Quieres conocerle mejor?"
    @show_notifications_link = true
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end


  def deleted_account(to)
    @title = "Cuenta eliminada :-("
    @subject = @title
    @show_notifications_link = false
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def comment_approved(to)
    @title = "Tu comentario ha sido aprobado :-)"
    @subject = @title
    @text = "El comentario que dejaste ayer en la noticia “Carril bici en Getxo” ha sido aprobado."
    @show_notifications_link = true
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def question_answered(to)
    @title = "Pregunta contestada en Irekia"
    @subject = @title
    @show_notifications_link = true
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def content_rejected(to)
    @title = "Tu comentario ha sido rechazado :-("
    @subject = @title
    @show_notifications_link = true
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end
end
