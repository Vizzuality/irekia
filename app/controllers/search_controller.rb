class SearchController < ApplicationController
  skip_before_filter :authenticate_user!,    :only => [:show]

  def show
    @search = OpenStruct.new(params[:search])

    @contents = AreaPublicStream.only_contents.search @search.query

    users     = User.search_by_name_description_province_and_city @search.query
    @citizens = users.citizens
    @politicians = users.politicians

    @contents_areas = @contents.inject([]){|arr, content| arr + [content.area]}.uniq!
    @citizens_areas = @citizens.inject([]){|arr, citizen| arr + citizen.areas}.uniq!
    @politicians_areas = @politicians.inject([]){|arr, politician| arr + politician.areas}.uniq!

    render :autocomplete, :layout => false and return if request.xhr?

  end

end

