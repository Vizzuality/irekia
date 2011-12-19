class ImagesController < ApplicationController

  def create
    @image = Image.new params[:image]
    if @image.save
      render :partial => 'contents/edit/image'
    else
      head :error
    end
  end

  def update
    @image = Image.find(params[:id])

    if @image.update_attributes params[:image]
      render :partial => 'contents/edit/image'
    else
      head :error
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    render :partial => 'contents/edit/image'
  end
end
