Codewatch::Application.routes.draw do
  devise_for :users

  get 'home/index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'home#index'

  get 'dashboard' => 'dashboard#index', as: :user_dashboard
  match 'edit/channel' => 'dashboard#edit_channel', as: :edit_user_channel, via: [ :get, :patch, :delete ]

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  get 'channel/:username' => 'channel#show', as: :user_channel

  get 'categories' => 'categories#index', as: :categories

  # Errors
  match '404' => 'errors#error404', via: [ :get, :post, :patch, :delete ]

  post 'chat/:chat_id/new_message' => 'chat#new_message'
  namespace :api do
    namespace :v1 do
      resource :auth, defaults: {format: 'json'} do
        post 'stream' => 'auth#stream', defaults: {format: 'json'}
      end
      resource :smil, defaults: {format: 'text'} do
        get ':username' => 'smil#generate', defaults: {format: 'text'}
      end
    end
  end
end
