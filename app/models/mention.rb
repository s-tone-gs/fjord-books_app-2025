# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioning, class_name: 'Report', inverse_of: :mentioning_relationship
  belongs_to :mentioned, class_name: 'Report', inverse_of: :mentioned_relationship

  validates :mentioning_id, uniqueness: { scope: :mentioned_id }
end
