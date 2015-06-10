class ImagesController < ApplicationController
  before_action :authenticate_user!
  def create
    pin = current_user.pins.find(params[:pin_id])
    picture = Picture.create(image: params[:image])
    pin.images << picture
    if pin.save
      respond_to do |format|
        format.json { render json: picture}
      end
    end
  end

  def destroy
    picture = Picture.find(params[:id])

    if picture.attachable_image.user == current_user && picture.destroy
      respond_to do |format|
        format.json {render json: :ok}
      end
    else
      respond_to do |format|
        format.json {render json: false, status: 401}
      end
    end
  end
end
