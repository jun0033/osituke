class Admin::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @hobbies = @user.hobbies.order(id: :desc).where(is_draft: false)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'プロフィールを変更しました。'
      redirect_to admin_user_path
    else
      flash[:danger] = 'プロフィールの変更に失敗しました。'
      render :edit
    end
  end

  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email, :user_status)
  end
end
