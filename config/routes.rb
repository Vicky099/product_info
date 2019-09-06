Rails.application.routes.draw do
	devise_for :users
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	devise_scope :user do
		root to: 'devise/sessions#new'
		get 'login', to: 'devise/sessions#new'
		delete 'logout', to: 'devise/sessions#destroy'
	end

	resources :products
end
