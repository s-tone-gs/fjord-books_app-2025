# frozen_string_literal: true

module CommentSetup
  def set_comments(commentable)
    @comments = commentable.comments.includes(:user).order(:id)
  end
end
