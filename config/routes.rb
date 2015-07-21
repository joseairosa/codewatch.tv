Codewatch::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get 'home/index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'home#index'

  get 'dashboard' => 'dashboard#index', as: :user_dashboard
  get 'dashboard/chat_management' => 'dashboard#chat_management', as: :user_dashboard_chat_management
  get 'dashboard/statistics' => 'dashboard#statistics', as: :user_dashboard_statistics
  get 'dashboard/stream_keys' => 'dashboard#stream_keys', as: :user_dashboard_stream_keys

  get 'dashboard/private_sessions' => 'dashboard#private_sessions', as: :user_dashboard_private_sessions
  post 'dashboard/private_sessions/create' => 'dashboard#create_private_session', as: :user_dashboard_private_sessions_create
  get 'dashboard/private_sessions/:id/edit' => 'dashboard#edit_private_session', as: :user_dashboard_private_sessions_edit
  post 'dashboard/private_sessions/:id/update' => 'dashboard#update_private_session', as: :user_dashboard_private_sessions_update
  put 'dashboard/private_sessions/:id/cancel' => 'dashboard#cancel_private_session', as: :user_dashboard_private_sessions_cancel

  get 'dashboard/subscriptions' => 'dashboard#subscriptions', as: :user_dashboard_subscriptions
  put 'dashboard/subscription/plus/:id/cancel' => 'dashboard#cancel_plus_subscription', as: :user_dashboard_plus_subscription_cancel
  put 'dashboard/subscription/channel/:id/cancel' => 'dashboard#cancel_channel_subscription', as: :user_dashboard_channel_subscription_cancel

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

  get 'events' => 'events#index', as: :events

  get 'help' => 'help#index', as: :help

  get 'channels/external' => 'external_streams#index', as: :external_channels
  get 'channel/external/:username' => 'external_streams#show', as: :user_external_channel

  get 'private_session/:id' => 'private_sessions#show', as: :private_session

  get 'payments/plus' => 'payments#new_plus', as: :new_plus_payment
  resources :payments
  get 'payments/private-session/:id' => 'payments#new_private_session', as: :new_private_session_payment
  get 'payments/plus/success' => 'payments#plus_success', as: :plus_success_payment
  get 'payments/channel_subscription/:id' => 'payments#new_channel_subscription', as: :channel_subscription_payment
  get 'payments/channel_subscription/:id/success' => 'payments#channel_subscription_success', as: :channel_subscription_success_payment

  get 'terms' => 'terms#show', as: :terms
  get 'privacy' => 'privacy#show', as: :privacy
  get 'about' => 'about#show', as: :about

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
        post 'event/:event' => 'recording#event', defaults: {format: 'json'}
      end
      resource :chat, defaults: {format: 'json'} do
        put ':channel_id/toggle_moderator/:username' => 'chat#toggle_moderator', defaults: {format: 'json'}, as: :chat_toggle_moderator
        put ':channel_id/ban/:username' => 'chat#ban', defaults: {format: 'json'}, as: :chat_ban
        put ':channel_id/unban/:username' => 'chat#unban', defaults: {format: 'json'}, as: :chat_unban
        delete ':channel_id/user/:username/delete/:message_id' => 'chat#remove_message', defaults: {format: 'json'}, as: :chat_remove_message
      end
      resource :private_session, defaults: {format: 'json'} do
        delete ':id/delete' => 'chat#toggle_moderator', defaults: {format: 'json'}, as: :delete
      end
      resource :channel, defaults: {format: 'json'} do
        post ':channel_id/like' => 'channel#like', defaults: {format: 'json'}, as: :channel_like
        delete ':channel_id/unlike' => 'channel#unlike', defaults: {format: 'json'}, as: :channel_unlike
      end
      resource :load_balancer, defaults: {format: 'json'} do
        post 'node' => 'load_balancer#stream', defaults: {format: 'json'}, as: :node
      end
    end
  end
end
