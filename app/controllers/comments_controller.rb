# frozen_string_literal: true

class CommentsController < ApplicationController
  include Authorization
  before_action only: %i[destroy] do
    authorize_user!(Comment, params.expect(:id))
  end

  def create
    set_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      @comment.save &&
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
    end
  end

  def destroy
    @comment = Comment.find(params.expect(:id))
    commentable = @comment.commentable
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
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
