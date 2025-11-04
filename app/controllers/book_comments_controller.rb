# frozen_string_literal: true

class BookCommentsController < CommentsController
  def set_commentable
    @commentable = Book.find(params[:book_id])
  end
end
