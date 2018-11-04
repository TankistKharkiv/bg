Rails.application.routes.draw do
  get 'company/index'
  get 'company/show'
  get 'company/update'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
