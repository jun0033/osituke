# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    if current_user.guest_user?
      current_user.destroy
    end
    super
  end

  protected
  # 退会しているかを判断するメソッド
  def user_state
    ## 【処理内容1】 入力されたnameからアカウントを1件取得
    @user = User.find_by(name: params[:user][:name])
    ## アカウントを取得できなかった場合、このメソッドを終了する
    return if !@user
    ## 【処理内容2】 取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別
    ## 【処理内容3】1と２がtrueならサインアップ画面に遷移する。
    if @user.valid_password?(params[:user][:password]) && @user.user_status == "withdraw"
        flash[:notice] = '退会済のアカウントです。'
        redirect_to new_user_registration_path
    end
  end

  # 新規登録後マイページへ遷移
  def after_sign_in_path_for(resource)
    random_hobby_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
