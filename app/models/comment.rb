# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  def posted_by
    user.name.empty? ? user.email : user.name
  end
end
