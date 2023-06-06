class GuestsController < ApplicationController
  def new_guest
    user = User.find_or_create_by!(name: 'guestuser', email: 'guest@example.com', user_status: false) do |user|
     user.password = SecureRandom.urlsafe_base64
     # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  sign_in user
  redirect_to hobbies_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end
