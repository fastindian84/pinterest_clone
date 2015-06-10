Rails.application.routes.draw do
  devise_for :users
  mount Commontator::Engine => '/commontator'
  resources :images, only: [:create, :destroy]
  resources :pins do
  	member do
  		put "like",    to: "pins#upvote"
  	end
  end

  root "pins#index"
end
