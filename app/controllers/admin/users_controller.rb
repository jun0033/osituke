class Admin::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @hobbies = @user.hobbies.where(is_draft: false)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールを変更しました。"
      redirect_to admin_user_path
    else
      flash[:notice] = "プロフィールの変更に失敗しました。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email, :user_status)
  end
end
