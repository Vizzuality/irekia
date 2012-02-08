class SearchesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :get_search_results, :except => [:politicians_and_areas]
  before_filter :get_contents, :only => [:show, :contents]
  before_filter :paginate, :only => [:show, :contents, :areas, :politicians, :citizens]

  def show
    @contents = @contents.limit(10)
    if request.xhr? && (params.key?('more_polemic') || params.key?('more_recent') || params.key?('type'))
      @show_title = true
      render :partial => 'contents_list' and return
    end

    if request.xhr?
      #head(:not_found) and return if @areas_found.blank? && @contents.blank? && @citizens.blank? && @politicians.blank?
      render :no_result, :layout => false and return if @areas_found.blank? && @contents.blank? && @citizens.blank? && @politicians.blank?
      render :autocomplete, :layout => false and return
    end
  end

  def contents

  end

  def politicians

  end

  def citizens

  end

  def politicians_and_areas
    @search_results               = {}
    @search_results[:politicians] = User.politicians.search_by_name(params[:search][:name]) unless params[:search][:only_areas]
    @search_results[:areas]       = Area.search_by_name(params[:search][:name])             unless params[:search][:only_politicians]

    render :layout => false
  end

  def get_search_results
    @search = OpenStruct.new(params[:search])

    @areas_found    = Area.search_by_name_and_description @search.query
    @contents       = AreaPublicStream.only_contents.search @search.query

    users        = User.search_by_name_description_province_and_city @search.query
    @citizens    = users.citizens
    @politicians = users.politicians
    @politicians = User.politicians if params[:all_politicians]

    @contents_count    = {
      :total     => @contents.count,
      :news      => @contents.news.count,
      :questions => @contents.questions.count,
      :proposals => @contents.proposals.count,
      :photos    => @contents.photos.count,
      :videos    => @contents.videos.count
    }
    @areas_found_count = @areas_found.count
    @politicians_count = @politicians.count
    @citizens_count    = @citizens.count


    @areas_follows = @areas_found.inject({}) do |follows, area|
      follows[area.id] = if current_user.blank? || current_user.not_following(area)
        follow          = area.follows.build
        follow.user     = current_user
        follow
      else
        follow = current_user.followed_item(area)
      end
      follows
    end

    @politicians_follows = @politicians.inject({}) do |follows, user|
      follows[user.id] = if current_user.blank? || current_user.not_following(user)
        follow          = user.follows.build
        follow.user     = current_user
        follow
      else
        follow = current_user.followed_item(user)
      end
      follows
    end
  end
  private :get_search_results

  def get_contents
    @contents = @contents.where(:event_type => params[:type].camelize) if params[:type].present?

    @contents = if params[:more_polemic]
      @contents.more_polemic
    else
      @contents.more_recent
    end
  end
  private :get_contents

  def paginate
    params[:page] = (params[:page] || 0).to_i + 1

    @per_page = 9
    if action_name == 'show' || params[:referer] == 'show'
      @contents    = @contents.page(params[:page]).per(4)    if @contents
    end

    @contents    = @contents.page(params[:page]).per(@per_page)    if @contents
    @politicians = @politicians.page(params[:page]).per(@per_page) if @politicians
    @citizens    = @citizens.page(params[:page]).per(@per_page)    if @citizens
  end
  private :paginate

end
