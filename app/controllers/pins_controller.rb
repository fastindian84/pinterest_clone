class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @pins = Pin.all.order("created_at DESC")
  end

  def show
    commontator_thread_show @pin
  end

  def new
    @pin = current_user.pins.build
  end

  def create
    @pin = current_user.pins.build(pin_params)

    if @pin.save
      respond_to do |format|
        format.json { render :json => @pin }
      end
    end
  end

  def edit
  end

  def update
    if @pin.update(pin_params)
      respond_to do |format|
				format.html {redirect_to @pin }
        format.json { render :json => @pin }
      end
    end
  end

  def destroy
    @pin.destroy
    redirect_to root_path
  end

  def upvote
    @pin.upvote_by current_user
    redirect_to :back
  end

  private
  def pin_params
    _params = params.require(:pin).permit(:title, :description, :price, :address, :latitude, :longitude)
		if params[:image].present?
    	_params.merge!(image: params[:image])
		end
    _params
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end

end
