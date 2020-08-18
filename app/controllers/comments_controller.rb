class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @comment = current_user.comments.build(comment_params)
    @micropost = @comment.micropost
    if @comment.save
      flash[:success] = "コメントを投稿しました"
      # コメントをしたタイミングで通知レコードを作成
      @micropost.create_notification_comment!(current_user, @comment.id)
      #redirect_to microposts_path
      #==>  micropost 詳細ページへ
      redirect_to root_url
    else
      flash.now[:notice]= "コメントに失敗しました"
      #redirect_to root_url
    end
  end

  def destroy
      @comment = Comment.find(params[:id])
      #本人がコメントしたコメントのみ削除できる
      if @comment && (current_user.id == @comment.user_id)
        if @comment.destroy
          redirect_to root_url
        else
          flash[:notice] = "コメントの削除に失敗しました"
        end
      end
  end


  private

    def comment_params
      params.required(:comment).permit(:comment, :micropost_id)
    end

end
