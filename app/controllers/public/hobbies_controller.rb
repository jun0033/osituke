class Public::HobbiesController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  def show
    begin
      @hobby    = Hobby.includes(:user, :hobby_comments, :tags).find(params[:id])
      @comment  = current_user.hobby_comments.new(hobby_id: @hobby.id)
      @comments = @hobby.hobby_comments.all.page(params[:page])
    rescue
      redirect_to hobbies_path
      flash[:danger] = "投稿が見つかりませんでした"
    end
  end

  def new
    @hobby  = Hobby.new
    @genre  = Genre.new
    @genres = Genre.all
  end

  def create
    @hobby  = Hobby.new
    @genre  = Genre.new
    @genres = Genre.all
    hobby = current_user.hobbies.new(hobby_params)
    # 受け取った値の全角空白を半角に変え左詰めし、空白で区切って配列にする
    tags  = params[:hobby][:tag_name].gsub(/　/," ").strip.split(/[　| ]+/)
     # 投稿ボタンを押下した場合
    if params[:post]
      # 投稿の場合のみバリデーション
      if hobby.save(context: :publicize)
        hobby.save_tag(tags)
        redirect_to hobbies_path
        flash[:success] = "#{hobby.title}が誰かの元へ飛んでいきました"
      else
        flash[:danger]  = '登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください'
        render :new
      end
    # 下書きボタンを押下した場合
    else
      if hobby.update(is_draft: true)
        hobby.save_tag(tags)
        redirect_to user_path(current_user)
        flash[:success] = "#{hobby.title}を下書き保存しました！"
      else
        flash[:danger]  = '登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください'
        render :new
      end
    end
  end

  def index
    user = User.where(user_status: false).pluck(:id)
    # 退会ユーザーと下書きの投稿を排除して表示
    @hobbies = Hobby.includes(:user).order(id: :desc).where(is_draft: false).where(user_id: user).page(params[:page])
  end

  def draft_index
    @draft_hobbies = Hobby.includes(:user).order(id: :desc).where(is_draft: true).where(user_id: current_user.id).page(params[:page])
  end

  def rank_index
    rank_ids = Favorite.group(:hobby_id)
                       .where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
                       .order('count(hobby_id) desc').pluck(:hobby_id)
    @rank_hobbies = Hobby.find(rank_ids)
  end

  def done_index
    @user    = User.find(params[:id])
    comments = HobbyComment.where(user_id: @user.id).where(done_status: true)
    @hobbies = Hobby.includes(:hobby_comments).order(id: :desc).where(id: comments.pluck(:hobby_id)).page(params[:page])
  end

  def destroy
    @hobby = Hobby.find(params[:id])
    @hobby.destroy
    flash[:warning] = '趣味を削除しました'
    redirect_to user_path(current_user)
  end

  def edit
    @hobby  = Hobby.find(params[:id])
    @genre  = Genre.new
    @genres = @hobby.genre
    @tags   = @hobby.tags.pluck(:tag_name).join(" ")
  end

  def update
    @hobby  = Hobby.find(params[:id])
    @genre  = Genre.new
    @genres = @hobby.genre
    @tags   = @hobby.tags.pluck(:tag_name).join(" ")
    tags = params[:hobby][:tag_name].gsub(/　/," ").strip.split(/[　| ]+/)
    # ①下書きの更新（公開）の場合
    if params[:publicize_draft]
      # 公開時にバリデーションを実施
      # updateメソッドにはcontextが使用できないため、公開処理にはattributesとsaveメソッドを使用する
      @hobby.attributes = hobby_params.merge(is_draft: false)
      if @hobby.save(context: :publicize)
        # 紐づいていたタグを消す
        @old_relations = HobbyTag.where(hobby_id: @hobby.id)
        @old_relations.destroy_all
        @hobby.save_tag(tags)
        redirect_to hobbies_path(@hobby.id)
        flash[:success] = "#{@hobby.title}が誰かの元へ飛んでいきました！"
      else
        @hobby.is_draft = true
        flash[:danger]  = "#{@hobby.title}を公開できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
        render :edit
      end
    # ②公開済み趣味の更新の場合
    elsif params[:update_hobby]
      @hobby.attributes = hobby_params
      if @hobby.save(context: :publicize)
        @old_relations = HobbyTag.where(hobby_id: @hobby.id)
        @old_relations.destroy_all
        @hobby.save_tag(tags)
        redirect_to hobbies_path(@hobby.id)
        flash[:success] = "#{@hobby.title}を更新しました！"
      else
        flash[:danger]  = "#{@hobby.title}を更新できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
        render :edit
      end
    # ③下書き趣味の更新（非公開）の場合
    else
      if @hobby.update(hobby_params)
        @old_relations  = HobbyTag.where(hobby_id: @hobby.id)
        @old_relations.destroy_all
        @hobby.save_tag(tags)
        redirect_to hobbies_path(@hobby.id)
        flash[:success] = '下書きを更新しました！'
      else
        flash[:danger]  = '更新できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください'
        render :edit
      end
    end
  end

  def random
    return redirect_to hobbies_path unless current_user.can_display_random?
    # ページの表示内容を設定
    seen_hobby_ids = current_user.hobby_comments.pluck(:hobby_id)
    todo_hobby_ids = current_user.to_does.pluck(:hobby_id)
    undone_hobbies =
    Hobby.where(is_draft: false)               # 公開設定の投稿
         .where.not(user_id: current_user.id)  # ログインユーザーの投稿でない
         .where.not(id: seen_hobby_ids)        # ログインユーザーがコメントを残してない
         .where.not(id: todo_hobby_ids)        # ログインユーザーのToDoにない
    @hobby = undone_hobbies.shuffle.first
    return redirect_to hobbies_path unless @hobby.present?
    current_user.update(last_random_displayed_at: Time.now)
    # ToDoに自動保存
    to_does = current_user.to_does.new(hobby_id: @hobby.id)
    to_does.save
  end

  private

  def hobby_params
    # 画像をハッシュで保存
    params.require(:hobby).permit(:title, :body, :tag_id, :genre_id, :is_draft, :tag_name, hobby_images: [])
  end

  def is_matching_login_user
    hobby = Hobby.find(params[:id])
    unless hobby.user.id == current_user.id
    redirect_to hobbies_path
    flash[:danger] = '他のユーザーの投稿の編集はできません'
    end
  end
end
