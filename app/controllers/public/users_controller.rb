class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    begin
      user     = User.where(user_status: false)
      @user    = User.find(params[:id])
      @hobbies = @user.hobbies.order(id: :desc).where(is_draft: false).where(user_id: user.pluck(:id))
    rescue
      redirect_to hobbies_path
      flash[:danger] = "ユーザーが見つかりませんでした"
    end
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
      flash[:danger]  = 'プロフィールの変更に失敗しました。'
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
      flash[:info]   = '退会しました。'
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
    user = User.find(params[:id])
    unless user.id == current_user.id
    redirect_to hobbies_path
    flash[:danger] = '他のユーザーの編集はできません'
    end
  end
end
