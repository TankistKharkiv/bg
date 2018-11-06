Rails.application.routes.draw do
  scope '/api', defaults: { format: :json } do
    devise_for :users, controllers: {sessions: 'sessions'},
               defaults: { format: :json }
    resources :companies, only: [:index, :show, :update]
    resources :users, only: [:index, :show, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
