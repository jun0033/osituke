class Admin::HobbiesController < ApplicationController
  def index
    @hobbies = Hobby.where(is_draft: false).page(params[:page])
  end

  def rank_index
    @rank_hobbies = Hobby.find(Favorite.group(:hobby_id).where(created_at: Time.current.all_month)
                         .order('count(hobby_id) desc').limit(10).pluck(:hobby_id))
  end

  def done_index
    user = User.find(params[:id])
    comments = HobbyComment.where(user_id: user.id).where(done_status: true)
    @hobbies = Hobby.where(id: comments.pluck(:hobby_id)).page(params[:page])
  end

  def show
    @hobby = Hobby.find(params[:id])
    @user = @hobby.user
    @comments = @hobby.hobby_comments.all.page(params[:page])
  end

  def destroy
    @hobby = Hobby.find(params[:id])
    @hobby.delete
    redirect_to admin_user_path(@hobby.user)
  end
end
