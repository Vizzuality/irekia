class SharesController < ApplicationController
  before_filter :get_content_class
  before_filter :get_content, :only => [:create]

  def create

    case params[:provider]
    when 'facebook'
      MiniFB.post(current_user.facebook_oauth_token, 'me', :type => 'feed', :message => "#{@content.facebook_share_message} #{url_for(@content)}")
    when 'twitter'
      Twitter.configure do |config|
        config.oauth_token = current_user.twitter_oauth_token
        config.oauth_token_secret = current_user.twitter_oauth_token_secret
      end
      Twitter.update(@content.twitter_share_message)
    when 'email'
      receiver = SharingTarget.new(params[:email])
      head :error and return  if receiver.invalid?
      SharingMailer.share_content(current_user, receiver, @content).deliver
    end

    head :ok
  end

  def get_content_class
    @content_class = params[:type].constantize
    @content_type = params[:type].downcase
  end
  private :get_content_class

  def get_content
    @content = @content_class.by_id(params["#{@content_type}_id"])
  end
  private :get_content
end
