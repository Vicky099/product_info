require 'sidekiq/web'
Rails.application.routes.draw do
	mount Sidekiq::Web => '/sidekiq'
	devise_for :users
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	devise_scope :user do
		root to: 'devise/sessions#new'
		get 'login', to: 'devise/sessions#new'
		delete 'logout', to: 'devise/sessions#destroy'
	end

	resources :products do
		collection do
			get :download
		end
	end
end
