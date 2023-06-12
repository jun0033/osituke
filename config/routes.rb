Rails.application.routes.draw do
  get 'searches/search'

  # 顧客用
  # URL /users/sign_in ...
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 管理者側のルーティング設定
  namespace :admin do
    resources :hobbies, only:[:index, :destroy, :show] do
      get 'rank_index', on: :collection
    end
    resources :users, only:[:show, :edit, :update] do
      member do
        get 'favorites' =>'favorites#index'
        get 'hobby_comments' =>'hobby_comments#index'
      end
    end
    root to: 'homes#top'
    resources :tags, only:[:create, :index, :show, :destroy]
  end

  # 会員側のルーティング設定
  scope module: :public do
    resources :users, only:[:update, :edit, :show] do
      resource :relationships, only: [:create, :destroy] do
        get "active_follow" => "relationships#active_follow", as: "active_follow"
        get "passive_follow" => "relationships#passive_follow", as: "passive_follow"
      end
      collection do
        get 'confirm'
        patch 'withdraw'
      end
      member do
        get 'favorites' =>'favorites#index'
        get 'to_does' =>'to_does#index'
        get 'hobby_comments' =>'hobby_comments#index'
      end
    end
    resources :hobbies, only:[:show, :index, :create, :destroy, :new, :edit, :update] do
      resource :favorites, only: [:create, :destroy]
      resource :to_does, only: [:create, :destroy]
      resources :hobby_comments, only:[:create, :destroy]
      collection do
        get 'draft_index'
        get 'rank_index'
      end
    end
    root to: 'homes#top'
    resources :tags, only:[:create, :index, :show]
  end
  post '/guests/guest_sign_in', to: 'guests#new_guest'
  post '/guests/admin_sign_in', to: 'guests#admin_guest'
  resources :notifications, only:[:index]
end
