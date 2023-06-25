class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    user = User.where(user_status: false)
    @user = User.find(params[:id])
    @hobbies = @user.hobbies.order(id: :desc).where(is_draft: false).where(user_id: user.pluck(:id))
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path
      flash[:success] = 'プロフィールを変更しました。'
    else
      flash[:danger] = 'プロフィールの変更に失敗しました。'
      redirect_to user_path
    end
  end

  def confirm
  end

  def withdraw
    @user = current_user
    if @user.update(user_status: true)
      reset_session
      redirect_to root_path
      flash[:info] = '退会しました。'
    else
      flash[:danger] = '編集に失敗しました'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email)
  end

  def is_matching_login_user
    user = current_user
    unless user.id == current_user.id
    redirect_to user_session_path
    end
  end
end
