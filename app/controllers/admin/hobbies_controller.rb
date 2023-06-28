class Admin::HobbiesController < ApplicationController
  def index
    # 下書き以外を表示
    @hobbies = Hobby.includes(:user).order(id: :desc).where(is_draft: false).page(params[:page])
  end

  def rank_index
    # 過去一か月のナイスの上位10件を多い順に取得
    hobbies       = Favorite.group(:hobby_id)
                            .where(created_at: Time.current.all_month)
                            .order('count(hobby_id) desc')
                            .limit(10).pluck(:hobby_id)
    @rank_hobbies = Hobby.includes(:favorites).where(id: hobbies).order(id: :desc)
  end

  def done_index
    user     = User.find(params[:id])
    comments = HobbyComment.where(user_id: user.id).where(done_status: true)
    # 趣味をやってみたかコメントから判断しリストを取得
    @hobbies = Hobby.includes(:hobby_comments).order(id: :desc).where(id: comments.pluck(:hobby_id)).page(params[:page])
  end

  def show
    @hobby    = Hobby.includes(:user, :hobby_comments, :tags).find(params[:id])
    @comments = @hobby.hobby_comments.all.page(params[:page])
  end

  def destroy
    @hobby = Hobby.find(params[:id])
    @hobby.destroy
    redirect_to admin_user_path(@hobby.user)
    flash[:warning] = '趣味を削除しました'
  end
end
