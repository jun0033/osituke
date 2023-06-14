class Admin::HobbyCommentsController < ApplicationController
  def index
    @user = User.find(params[:id])
    @comments = HobbyComment.where(user_id: @user.id).page(params[:page])
  end
end
