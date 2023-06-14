class SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザー"
    @users = User.order(id: :desc).looks(@word).page(params[:page])
    render "/searches/search"
    else
    user = User.where(user_status: false)
    @hobbies = Hobby.order(id: :desc).looks(@word).where(user_id: user.pluck(:id)).page(params[:page])
    render "/searches/search"
    end
  end
end
