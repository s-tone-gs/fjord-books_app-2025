class CommentsController < ApplicationController
  before_action :permit_access, only: [:destroy]

  def create
    set_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: 'コメントを投稿しました' }
      else
        format.html { refirect_to @commentable, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params.expect(:id))
    commentable = @comment.commentable
    @comment.destroy!
    
    respond_to do |format|
      format.html { redirect_to commentable, notice: 'コメントを削除しました' }
    end
  end

  private

  def set_commentable
    @commentable =
    if params[:book_id]
      Book.find(params[:book_id])
    elsif params[:report_id]
      Report.find(params[:report_id])
    end
  end
    
  def permit_access
    owner = Comment.find(params[:id]).user
    unless owner == current_user
      redirect_to reports_path, notice: 'アクセス権限がありません'
    end
  end

  def comment_params
    params.expect(comment: [:body])
  end
end
