Codewatch::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get 'home/index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'home#index'

  get 'dashboard' => 'dashboard#index', as: :user_dashboard
  match 'edit/channel' => 'dashboard#edit_channel', as: :edit_user_channel, via: [ :get, :post, :delete ]

  post 'dashboard/update_user' => 'dashboard#update_user', as: :update_user
  post 'dashboard/update_settings' => 'dashboard#update_settings', as: :update_settings
  post 'dashboard/update_password' => 'dashboard#update_password', as: :update_password

  get 'dashboard/vod/delete/:id' => 'dashboard#delete_vod', as: :delete_vod
  get 'dashboard/vod/toggle_visibility/:id' => 'dashboard#show_hide_vod', as: :toggle_vod_visibility

  get 'channel/:username' => 'channel#show', as: :user_channel

  get 'categories/:category_name' => 'categories#show', as: :category_channels

  get 'categories' => 'categories#index', as: :categories

  get 'search' => 'search#search', as: :search

  get 'vod/:username' => 'vod#index', as: :list_vod
  get 'vod/:username/:recording_id' => 'vod#show', as: :show_vod

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
      resource :stream, defaults: {format: 'json'} do
        post 'new_recording' => 'stream#new_recording', defaults: {format: 'json'}
        post 'event/:event' => 'stream#event', defaults: {format: 'json'}
      end
      resource :recording, defaults: {format: 'json'} do
        post 'stats/:event' => 'recording#stats', defaults: {format: 'json'}
      end
      resource :chat, defaults: {format: 'json'} do
        put ':channel_id/toggle_moderator/:username' => 'chat#toggle_moderator', defaults: {format: 'json'}, as: :chat_toggle_moderator
        put ':channel_id/ban/:username' => 'chat#ban', defaults: {format: 'json'}, as: :chat_ban
      end
    end
  end
end
