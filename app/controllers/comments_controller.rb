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

    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render 'reports/show', status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params.expect(:id))
    commentable = @comment.commentable
    @comment.destroy!

    redirect_to commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_commentable
    # @commentableにコメント対象のオブジェクトを代入するメソッド
    # 子クラスで必ずオーバーライドする
    # 例）
    # @commentable = Book.find(params[:book_id])
  end

  def comment_params
    params.expect(comment: [:body])
  end
end
