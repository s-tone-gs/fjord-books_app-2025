# frozen_string_literal: true

class BookCommentsController < CommentsController
  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def render_failure
    @book = @commentable
    @comments = Comment.comments_to_commentable(@commentable)
    render 'books/show', status: :unprocessable_entity
  end
end
