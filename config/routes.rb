Rails.application.routes.draw do
  namespace :admin do
    get 'hobby_comments/index'
  end
  namespace :admin do
    get 'tags/index'
  end
  namespace :admin do
    get 'hobbies/index'
  end
  namespace :admin do
    get 'users/show'
    get 'users/edit'
  end
  namespace :admin do
    get 'homes/top'
  end
  namespace :public do
    get 'tags/index'
  end
  namespace :public do
    get 'hobby_comments/index'
  end
  namespace :public do
    get 'users/show'
    get 'users/edit'
    get 'users/confirm'
  end
  namespace :public do
    get 'hobbies/show'
    get 'hobbies/index'
    get 'hobbies/edit'
  end
  namespace :public do
    get 'homes/top'
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
