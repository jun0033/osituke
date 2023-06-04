Rails.application.routes.draw do

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
    resources :hobby_comments, only:[:index, :destroy]
    resources :hobbies, only:[:index, :destroy]
    resources :users, only:[:show, :edit, :update]
    root to: 'homes#top'
    get 'admin/tags' =>'tags#index'
  end

  # 会員側のルーティング設定
  scope module: :public do
    resources :users, only:[:update, :edit, :show] do
      collection do
        get 'confirm'
        patch 'withdraw'
      end
      resources :hobbies, only:[:show, :edit, :index, :create, :destroy, :new] do
        resource :favorite, only: [:create, :destroy]
        resources :hobby_comments, only:[:index, :create, :destroy]
      end
      resource :relationships, only: [:create, :destroy] do
        get "active_follow" => "relationships#active_follow", as: "active_follow"
        get "passive_follow" => "relationships#passive_follow", as: "passive_follow"
      end
    end
    root to: 'homes#top'
    resources :tags, only:[:create, :index]
  end
end
