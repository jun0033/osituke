Rails.application.routes.draw do

  # 管理者側のルーティング設定
  namespace :admin do
    resources :hobby_comments, only:[:index, :destroy]
    resources :hobbies, only:[:index, :destroy]
    resources :users, only:[:show, :edit, :update]
    root to: 'homes#top'
    get 'admin/tags/:id' =>'tags#index'
  end

  # 会員側のルーティング設定
  scope module: :public do
    resources :hobby_comments, only:[:index, :create, :destroy]
    resources :hobbies, only:[:show, :edit, :index, :create, :destroy]
    get 'users/mypage' => 'customers#show'
    resources :users, only:[:update, :edit] do
      collection do
        get 'confirm'
        patch 'withdraw'
      end
    end
    root to: 'homes#top'
    get '/tags/:id' =>'tags#index'
  end

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
end
