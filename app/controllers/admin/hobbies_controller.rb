class Admin::HobbiesController < ApplicationController
  def index
    @hobbies = Hobby.where(is_draft: false)
  end

  def show
    @hobby = Hobby.find(params[:id])
    @user = @hobby.user
    @comments = @hobby.hobby_comments.all
  end

  def destroy
    @hobby = Hobby.find(params[:id])
    @hobby.delete
    redirect_to admin_user_path(@hobby.user)
  end
end
