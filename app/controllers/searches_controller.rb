class SearchesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :get_search_results, :except => [:politicians_and_areas]
  before_filter :get_contents, :only => [:show, :contents]
  before_filter :paginate, :only => [:show, :contents]

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
    @politicians = User.politicians.search_by_name(params[:search][:name]) unless params[:search][:only_areas]
    @areas       = Area.search_by_name(params[:search][:name])

    render :layout => false
  end

  def get_search_results
    @search = OpenStruct.new(params[:search])

    @areas_found    = Area.search_by_name_and_description @search.query
    @contents       = AreaPublicStream.only_contents.search @search.query

    users        = User.search_by_name_description_province_and_city @search.query
    @citizens    = users.citizens
    @politicians = users.politicians

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
  end
  private :get_search_results

  def get_contents
    @contents = @contents.where(:event_type => params[:type]) if params[:type].present?

    @contents = if params[:more_polemic]
      @contents.more_polemic
    else
      @contents.more_recent
    end
  end
  private :get_contents

  def paginate
    if action_name == 'show' || params[:referer] == 'show'
      @contents   = @contents.page(1).per(4)   if @contents
    else
      @contents   = @contents.page(params[:page]).per(10)   if @contents
    end
    @politicians = @politicians.page(params[:page]).per(10) if @politicians
    @citizens    = @citizens.page(params[:page]).per(10) if @citizens
  end
  private :paginate
end


