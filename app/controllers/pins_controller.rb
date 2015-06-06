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
		pins = []
		if params[:images].present?
			params[:images].each do |image|
				pin = current_user.pins.build(pin_params.merge(image: image))
				pins << pin
			end
		end
		if pins.map(&:save).all?
			if pins.count == 1
				redirect_to pins.first, notice: "Pin was successfully created"
			else
				redirect_to action: :index
			end
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @pin.update(pin_params)
			redirect_to @pin, notice: "Pin was successfully updated"
		else
			render 'edit'
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
		params.require(:pin).permit(:title, :description, :price)
	end

	def find_pin
		@pin = Pin.find(params[:id])
	end

end
