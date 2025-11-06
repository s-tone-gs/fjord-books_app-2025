# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioning, class_name: 'Report', inverse_of: :mentioning_relationship
  belongs_to :mentioned, class_name: 'Report', inverse_of: :mentioned_relationship

  validates :mentioning_id, uniqueness: { scope: :mentioned_id }
  validate :prevent_self_reference

  def prevent_self_reference
    return unless mentioning_id.equal?(mentioned_id)

    errors.add(:mentioning, I18n.t('errors.messages.self_reference', model: Report.model_name.human))
  end
end
