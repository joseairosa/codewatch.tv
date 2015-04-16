Codewatch::Application.routes.draw do
  devise_for :users

  get 'home/index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'home#index'

  get 'dashboard' => 'dashboard#index', as: :user_dashboard

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  resources :channel

  post 'chat/:chat_id/new_message' => 'chat#new_message'
  namespace :api do
    namespace :v1 do
      resource :auth, defaults: {format: 'json'} do
        post 'stream' => 'auth#stream', defaults: {format: 'json'}
      end
    end
  end
end
