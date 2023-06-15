class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def show
    user = User.where(user_status: false)
    @user = User.find(params[:id])
    @hobbies = @user.hobbies.where(is_draft: false).where(user_id: user.pluck(:id))
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールを変更しました。"
      redirect_to user_path
    else
      flash[:notice] = "プロフィールの変更に失敗しました。"
      render :edit
    end
  end

  def confirm
  end

  def withdraw
    @user = current_user
    if @user.update(user_status: true)
      reset_session
      flash[:notice] = "退会しました。"
      redirect_to root_path
    else
      flash[:alert] = "編集に失敗しました"
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

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
    redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
