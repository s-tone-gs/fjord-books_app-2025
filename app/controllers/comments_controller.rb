class CommentsController < ApplicationController
  include Authorization
  before_action only: %i[ destroy ] do
    authorize_user!(Comment, params[:id])
  end

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

  def comment_params
    params.expect(comment: [:body])
  end
end
