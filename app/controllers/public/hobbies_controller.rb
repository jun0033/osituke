class Public::HobbiesController < ApplicationController
  def show
    @hobby = Hobby.find(params[:id])
    @user = @hobby.user
    @comment = current_user.hobby_comments.new(hobby_id: @hobby.id)
    @comments = @hobby.hobby_comments.all
    @favorite = Favorite.find_by(hobby_id: @hobby.id)
    @already_comment = @comments.find_by(user_id: current_user.id, done_status: true)
  end

  def new
    @hobby = Hobby.new
    @tag = Tag.new
    @tags = Tag.all
  end

  def create
    hobby = current_user.hobbies.new(hobby_params)
     # 投稿ボタンを押下した場合
    if params[:post]
      if hobby.save(context: :publicize)
        redirect_to hobbies_path, notice: "#{hobby.title}が誰かの元へ飛んでいきました"
      else
        render :new, alert: "登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
      end
    # 下書きボタンを押下した場合
    else
      if hobby.update(is_draft: true)
        redirect_to user_path(current_user), notice: "#{hobby.title}を下書き保存しました！"
      else
        render :new, alert: "登録できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
      end
    end
  end

  def index
    @hobbies = Hobby.where(is_draft: false)
  end

  def draft_index
    @draft_hobbies = Hobby.where(is_draft: true,user_id: current_user.id)
  end

  def rank_index
    @rank_hobbies = Hobby.find(Favorite.group(:hobby_id).where(created_at: Time.current.all_month)
                         .order('count(hobby_id) desc').limit(10).pluck(:hobby_id))
  end

  def done_index
    user = User.find(params[:id])
    comments = HobbyComment.where(user_id: user.id).where(done_status: true)
    @hobbies = Hobby.where(id: comments.pluck(:hobby_id))
  end

  def destroy
    @hobby = Hobby.find(params[:id])
    @hobby.delete
    redirect_to user_path(current_user)
  end

  def edit
    @hobby = Hobby.find(params[:id])
  end

  def update
    @hobby = Hobby.find(params[:id])
    # ①下書きの更新（公開）の場合
    if params[:publicize_draft]
      # 公開時にバリデーションを実施
      # updateメソッドにはcontextが使用できないため、公開処理にはattributesとsaveメソッドを使用する
      @hobby.attributes = hobby_params.merge(is_draft: false)
      if @hobby.save(context: :publicize)
        redirect_to hobbies_path(@hobby.id), notice: "#{@hobby.title}が誰かの元へ飛んでいきました！"
      else
        @hobby.is_draft = true
        render :edit, alert: "#{@hobby.title}を公開できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
      end
    # ②公開済みレシピの更新の場合
    elsif params[:update_hobby]
      @hobby.attributes = hobby_params
      if @hobby.save(context: :publicize)
        redirect_to hobbies_path(@hobby.id), notice: "#{@hobby.title}を更新しました！"
      else
        render :edit, alert: "#{@hobby.title}を更新できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
      end
    # ③下書きレシピの更新（非公開）の場合
    else
      if @hobby.update(hobby_params)
        redirect_to hobbies_path(@hobby.id), notice: "下書きを更新しました！"
      else
        render :edit, alert: "更新できませんでした。お手数ですが、入力内容をご確認のうえ再度お試しください"
      end
    end
  end

  private

  def hobby_params
    # 画像をハッシュで保存
    params.require(:hobby).permit(:title, :body, :tag_id, :is_draft, hobby_images:[])
  end
end
