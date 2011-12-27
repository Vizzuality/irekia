module PoliticiansHelper
  include ApplicationHelper

  def page_title
    @title = ['IREKIA']
    if @politician.present?
      @title << @politician.fullname
      @title << t(params[:action], :scope => 'politicians.menu') if params[:action]
    end
    @title.join(' - ')
  end

  def link_for_actions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:type]         = params[:type] unless filters.key?(:type)
    actions_politician_path(@politician, filters)
  end

  def link_for_proposals(filters = {})
    filters[:more_polemic]     = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:from_politicians] = params[:from_politicians] unless filters.key?(:from_politicians)
    filters[:from_citizens]    = params[:from_citizens] unless filters.key?(:from_citizens)

    proposals_politician_path(@politician, filters)
  end

  def link_for_questions(filters = {})
    filters[:more_polemic] = params[:more_polemic] unless filters.key?(:more_polemic)
    filters[:answered]     = params[:answered] unless filters.key?(:answered)

    questions_politician_path(@politician, filters)
  end

  def link_for_agenda(filters = {})
    agenda_politician_path(@politician, filters)
  end

  def politician_address
    return unless @politician.city.present? && @politician.province.present?

    content_tag :p, "#{@politician.city}, #{@politician.province}"
  end

  def politician_mail_and_phone
    return unless @politician.email.present? || @politician.phone_number.present?
    arr = []
    arr << @politician.email if @politician.email.present?
    arr << @politician.phone_number if @politician.phone_number.present?

    content_tag :p, arr.join(' | ')
  end

  def politician_twitter_and_facebook
    return unless @politician.twitter_username.present? || @politician.facebook_url.present?
    arr = []
    arr << link_to("@#{@politician.twitter_username}", "http://twitter.com/#{@politician.twitter_username}") if @politician.twitter_username.present?
    arr << link_to(@politician.facebook_url, @politician.facebook_url) if @politician.facebook_url.present?

    content_tag :p, raw(arr.join(' | '))
  end
end
