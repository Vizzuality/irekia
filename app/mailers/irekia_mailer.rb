# encoding: utf-8

class IrekiaMailer < ActionMailer::Base

  default :from => "from@example.com"

  layout 'mail'

  def welcome(to)
    @title = "Bienvenido a Irekia, Javier :-)"
    @subject = @title
    @text = "Gracias por registrarte en Irekia. ¡Ya puedes empezar a participar!"
    @show_notifications_link = false
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def reset_password(to)
    @title = "¿No te acuerdas de tu contraseña?"
    @subject = @title
    @text = "Simplemente pulsa el enlace “Regenerar contraseña”. Irekia te pedirá a continuación el nuevo valor."
    @show_notifications_link = false
    mail(:to => to, :bcc => ['aitor_garcia_ibarra@hotmail.com', 'aitana_muguzola@yahoo.es'], :subject => @subject)
  end

  def new_question(question)
    if question.target_user

      I18n.with_locale question.target_user.locale || I18n.default_locale do

        @subject = @title        = t('irekia_mailer.new_question.subject')
        @subtitle                = t('irekia_mailer.new_question.user_asks_you', :user => question.author.fullname)
        @show_notifications_link = false
        @question_text           = question.question_text
        @question_url            = question_url(question.slug, :locale => I18n.locale)

        mail(:to => question.target_user.email, :subject => @subject)
      end

    elsif question.target_area

      question.target_area.team.each do |politician|

        I18n.with_locale politician.locale || I18n.default_locale do
          @subject = @title        = t('irekia_mailer.new_question.subject')
          @subtitle                = t('irekia_mailer.new_question.user_asks_your_area', :user => question.author.fullname)
          @show_notifications_link = false
          @question_text           = question.question_text
          @question_url            = question_url(question.slug, :locale => I18n.locale)

          mail(:to => politician.email, :subject => @subject)
        end

      end
    end
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

  def question_answered(answer)
    question_author = answer.question.author

    I18n.with_locale question_author.locale || I18n.default_locale do
      @user_settings_url       = settings_user_url(question_author, :locale => I18n.locale)
      @subject = @title        = t('irekia_mailer.question_answered.subject')
      @question_text           = answer.question_text
      @question_url            = question_url(answer.question.slug, :locale => I18n.locale)
      @answer                  = answer.answer_text
      politician_title         = t('irekia_mailer.question_answered.politician_title', :title => answer.author.title.get_translated_name, :area => answer.author.areas.first.name) if answer.author.title.present?
      @politician_with_title   = [answer.author.fullname, politician_title].compact.join(', ')
      @show_notifications_link = true

      mail(:to => question_author.email, :subject => @subject)
    end
  end

  def moderation_approved(item)
    @user_settings_url       = settings_user_url(item.author, :locale => I18n.locale)
    @item_type               = item.class.model_name.human.downcase
    @subject = @title        = t("irekia_mailer.moderation_approved.subject.#{item.class.name.downcase}")
    @detail                  = if item.parent.present?
      t("irekia_mailer.moderation_approved.detail_with_parent.#{item.parent.class.name.downcase}", :item => @item_type, :parent_text => item.parent.text)
    else
      t('irekia_mailer.moderation_approved.detail', :item => @item_type, :item_text => item.text)
    end
    @show_notifications_link = true

    mail(:to => item.author.email, :subject => @subject)
  end

  def moderation_rejected(item)
    @user_settings_url       = settings_user_url(item.author, :locale => I18n.locale)
    @item_type               = item.class.model_name.human.downcase
    @subject = @title        = t("irekia_mailer.moderation_rejected.subject.#{item.class.name.downcase}")
    @detail                  = if item.parent.present?
      t("irekia_mailer.moderation_rejected.detail.#{item.parent.class.name.downcase}", :item => @item_type, :parent_text => item.parent.text)
    end
    @item_was = t("irekia_mailer.moderation_rejected.item_was.#{item.class.name.downcase}")
    @contents = []
    case item
    when Comment
      @contents << item.body
    when Argument
      @contents << item.reason
    when Question
      @contents << item.question_text
      @contents << item.body
    when Proposal
      @contents << item.title
      @contents << item.body
    end

    mail(:to => item.author.email, :subject => @subject)
  end

end
