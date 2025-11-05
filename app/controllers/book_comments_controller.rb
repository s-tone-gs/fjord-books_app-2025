# frozen_string_literal: true

class BookCommentsController < CommentsController
  include CommentSetup
  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def render_failure
    @book = @commentable
    @comments = setup_comments(@commentable)
    render 'books/show', status: :unprocessable_entity
  end
end
