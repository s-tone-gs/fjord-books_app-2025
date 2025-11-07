# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  def self.comments_to_commentable(commentable)
    commentable.comments.includes(:user).order(:id)
  end
end
