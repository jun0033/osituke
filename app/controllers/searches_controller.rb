class SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == 'ユーザー'
      if user_signed_in?
        user = User.where(user_status: false)
        @users = User.order(id: :desc).looks(@word).where(id: user.pluck(:id)).page(params[:page])
      else
        @users = User.order(id: :desc).looks(@word).page(params[:page])
      end
      render "/searches/search"
    else
      if user_signed_in?
        user = User.where(user_status: false)
        @hobbies = Hobby.order(id: :desc).looks(@word).where(user_id: user.pluck(:id)).page(params[:page])
      else
        @hobbies = Hobby.order(id: :desc).looks(@word).page(params[:page])
      end
      render "/searches/search"
    end
  end
end
