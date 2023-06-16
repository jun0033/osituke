class Public::HobbiesController < ApplicationController
  def show
    @hobby = Hobby.find(params[:id])
    @user = @hobby.user
    @comment = current_user.hobby_comments.new(hobby_id: @hobby.id)
    @comments = @hobby.hobby_comments.all.page(params[:page])
    @favorite = Favorite.find_by(hobby_id: @hobby.id)
    # 自分の完了報告があるか調べる
    @report_comment = @comments.find_by(user_id: current_user.id, done_status: true)
    @tags = @hobby.tags
  end

  def new
    @hobby = Hobby.new
    @genre = Genre.new
  end

  def create
    hobby = current_user.hobbies.new(hobby_params)
    tags = params[:hobby][:tag_name].split(/[　| ]/)
     # 投稿ボタンを押下した場合
    if params[:post]
      # 投稿の場合のみバリデーション
      if hobby.save(context: :publicize)
        hobby.save_tag(tags)
        redirect_to hobbies_path, notice: "#{hobby.title}が誰かの元へ飛んでいきました"
      else
        flash[:danger] = '登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください'
        render :new
      end
    # 下書きボタンを押下した場合
    else
      if hobby.update(is_draft: true)
        hobby.save_tag(tags)
        redirect_to user_path(current_user)
        flash[:success] = "#{hobby.title}を下書き保存しました！"
      else
        flash[:danger] = '登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください'
        render :new
      end
    end
  end

  def index
    user = User.where(user_status: false)
    # 退会ユーザーと下書きの投稿を排除して表示
    @hobbies = Hobby.order(id: :desc).where(is_draft: false).where(user_id: user.pluck(:id)).page(params[:page])
  end

  def draft_index
    @draft_hobbies = Hobby.order(id: :desc).where(is_draft: true).where(user_id: current_user.id).page(params[:page])
  end

  def rank_index
    @rank_hobbies = Hobby.find(Favorite.group(:hobby_id).where(created_at: Time.current.all_month)
                         .order('count(hobby_id) desc').limit(10).pluck(:hobby_id))
  end

  def done_index
    @user = User.find(params[:id])
    comments = HobbyComment.where(user_id: @user.id).where(done_status: true)
    @hobbies = Hobby.order(id: :desc).where(id: comments.pluck(:hobby_id)).page(params[:page])
  end

  def destroy
    @hobby = Hobby.find(params[:id])
    @hobby.destroy
    flash[:warning] = '趣味を削除しました'
    redirect_to user_path(current_user)
  end

  def edit
    @hobby = Hobby.find(params[:id])
    @genre = Genre.new
    @genres = @hobby.genre
    @tags = @hobby.tags.pluck(:tag_name).join(" ")
  end

  def update
    @hobby = Hobby.find(params[:id])
     # 受け取った値を空白で区切って配列にする
    tags = params[:hobby][:tag_name].split(/[　| ]/)
    # ①下書きの更新（公開）の場合
    if params[:publicize_draft]
      # 公開時にバリデーションを実施
      # updateメソッドにはcontextが使用できないため、公開処理にはattributesとsaveメソッドを使用する
      @hobby.attributes = hobby_params.merge(is_draft: false)
      if @hobby.save(context: :publicize)
        # 紐づいていたタグを消す
        @old_relations = HobbyTag.where(hobby_id: @hobby.id)
        @old_relations.each do |relation|
          relation.delete
        end
        @hobby.save_tag(tags)
        redirect_to hobbies_path(@hobby.id)
        flash[:success] = "#{@hobby.title}が誰かの元へ飛んでいきました！"
      else
        @hobby.is_draft = true
        flash[:danger] = "#{@hobby.title}を公開できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
        render :edit
      end
    # ②公開済み趣味の更新の場合
    elsif params[:update_hobby]
      @hobby.attributes = hobby_params
      if @hobby.save(context: :publicize)
        @old_relations = HobbyTag.where(hobby_id: @hobby.id)
        @old_relations.each do |relation|
          relation.delete
        end
        @hobby.save_tag(tags)
        redirect_to hobbies_path(@hobby.id)
        flash[:success] = "#{@hobby.title}を更新しました！"
      else
        flash[:danger] = "#{@hobby.title}を更新できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
        render :edit
      end
    # ③下書き趣味の更新（非公開）の場合
    else
      if @hobby.update(hobby_params)
        @old_relations = HobbyTag.where(hobby_id: @hobby.id)
        @old_relations.each do |relation|
          relation.delete
        end
        @hobby.save_tag(tags)
        redirect_to hobbies_path(@hobby.id)
        flash[:success] = '下書きを更新しました！'
      else
        flash[:danger] = '更新できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください'
        render :edit
      end
    end
  end

  def random
    if current_user.can_display_random?
      current_user.update(last_random_displayed_at: Time.now)
      # ページの表示内容を設定
      comments = HobbyComment.where.not(user_id: current_user.id)
      hobbies = Hobby.where(is_draft: false).where.not(user_id: current_user.id).where.not(id: comments.pluck(:hobby_id))
      @hobby = hobbies.random
      unless @hobby == nil
        # ToDoに自動保存
        to_does = current_user.to_does.new(hobby_id: @hobby.id)
        to_does.save
      end
    else
      redirect_to hobbies_path
    end
  end

  private

  def hobby_params
    # 画像をハッシュで保存
    params.require(:hobby).permit(:title, :body, :tag_id, :genre_id, :is_draft, hobby_images:[])
  end
end
