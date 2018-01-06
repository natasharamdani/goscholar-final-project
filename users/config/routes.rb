Rails.application.routes.draw do
  root 'home#index', as: 'home'

  resources :users do
    member do
      get   'topup'
      patch 'topup' => 'users#do_topup'
    end
  end

  resources :orders
  scope :format => true, :constraints => { :format => 'json' } do
    get 'orders'            => 'orders#driver'
    put 'orders/:id/update' => 'orders#update'
  end
  get 'orders/:id/cancel' => 'orders#cancel', as: 'cancel'

  controller :sessions do
    get    'login'  => :new
    post   'login'  => :create
    delete 'logout' => :destroy
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
