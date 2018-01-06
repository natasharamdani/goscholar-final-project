Rails.application.routes.draw do
  root 'home#index', as: 'home'

  resources :drivers

  scope :format => true, :constraints => { :format => 'json' } do
    get 'fleets' => 'fleets#index'
  end

  get 'orders' => 'orders#index'

  controller :sessions do
    get    'login'  => :new
    post   'login'  => :create
    delete 'logout' => :destroy
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
