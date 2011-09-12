class SearchController < ApplicationController
  skip_before_filter :authenticate_user!,    :only => [:show]

  def show
    @search = OpenStruct.new(params[:search])

    @contents = AreaPublicStream.only_contents.search @search.q

    users     = User.search_by_name_description_province_and_city @search.q
    @citizens = users.citizens
    @politics = users.politics

    @contents_areas = @contents.inject([]){|arr, content| arr + [content.area]}.uniq!
    @citizens_areas = @citizens.inject([]){|arr, citizen| arr + citizen.areas}.uniq!
    @politics_areas = @politics.inject([]){|arr, politic| arr + politic.areas}.uniq!

    render :autocomplete, :layout => false and return if request.xhr?

  end

end

