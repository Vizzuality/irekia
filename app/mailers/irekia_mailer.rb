# encoding: utf-8

class IrekiaMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default :from => "Lehendakaritza, Irekia <irekia@ej-gv.es>"

  layout 'mail'

  def welcome(user)
    I18n.with_locale user.locale || I18n.default_locale do
      @subject =  @title       =  t('irekia_mailer.welcome.subject', :name => user.name)
      @profile_url             = root_url
      @text                    =  t('irekia_mailer.welcome.text')
      @step_1                  =  t('irekia_mailer.welcome.step_1')
      @step_1_detail           =  t('irekia_mailer.welcome.step_1_detail')
      @step_2                  =  t('irekia_mailer.welcome.step_2')
      @step_2_detail           =  t('irekia_mailer.welcome.step_2_detail')
      @step_3                  =  t('irekia_mailer.welcome.step_3')
      @step_3_detail           =  t('irekia_mailer.welcome.step_3_detail')
      @access_irekia           =  t('irekia_mailer.welcome.access_irekia')
      @show_notifications_link =  false

      mail(:to => user.email, :subject => @subject)
    end
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

  def new_follower(follow)
    follower           = follow.user
    followed           = follow.follow_item

    I18n.with_locale followed.locale || I18n.default_locale do
      @subject = @title  = t('irekia_mailer.new_follower.subject')
      @text              = t('irekia_mailer.new_follower.text',        :name => follower.fullname)
      @see_profile       = t('irekia_mailer.new_follower.see_profile', :name => follower.name)
      @profile_url       = user_url(follower, :locale => I18n.locale)
      @user_settings_url = settings_user_url(followed, :locale => I18n.locale)

      @show_notifications_link = true
      mail(:to => followed.email, :subject => @subject)
    end
  end


  def deleted_account(user)

    I18n.with_locale user.locale || I18n.default_locale do
      @subject = @title        = t('irekia_mailer.deleted_account.subject')
      @as_requested            = t('irekia_mailer.deleted_account.as_requested')
      @come_back               = t('irekia_mailer.deleted_account.come_back', :url => root_url)
      @cheers                  = t('irekia_mailer.deleted_account.cheers')
      @irekia_team             = t('irekia_mailer.deleted_account.irekia_team')
      @show_notifications_link = false

      mail(:to => user.email, :subject => @subject)
    end
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
    author = item.author

    I18n.with_locale author.locale || I18n.default_locale do
      @user_settings_url       = settings_user_url(author, :locale => I18n.locale)
      @item_type               = item.class.model_name.human.downcase
      @item_url                = polymorphic_url(item.parent || item, :locale => I18n.locale)
      @subject = @title        = t("irekia_mailer.moderation_approved.subject.#{item.class.name.downcase}")
      @detail                  = if item.parent.present?
        t("irekia_mailer.moderation_approved.detail_with_parent.#{item.parent.class.name.downcase}", :item => @item_type, :parent_text => item.parent.text)
      else
        t('irekia_mailer.moderation_approved.detail', :item => @item_type, :item_text => item.text)
      end
      @show_notifications_link = true

      mail(:to => author.email, :subject => @subject)
    end
  end

  def moderation_rejected(item)
    author = item.author

    I18n.with_locale author.locale || I18n.default_locale do
      @user_settings_url       = settings_user_url(author, :locale => I18n.locale)
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

end
