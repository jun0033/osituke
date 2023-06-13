class SearchesController < ApplicationController

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザー"
    @users = User.looks(@word)
    render "/searches/search"
    else
    user = User.where(user_status: false)
    @hobbies = Hobby.looks(@word).where(user_id: user.pluck(:id))
    render "/searches/search"
    end
  end

end
