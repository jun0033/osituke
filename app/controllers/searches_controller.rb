class SearchesController < ApplicationController

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザー"
    @users = User.looks(@word)
    render "/searches/search"
    else
    @hobbies = Hobby.looks(@word)
    render "/searches/search"
    end
  end

end
