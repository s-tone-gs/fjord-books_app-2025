# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  # 自分が言及元＝相手の言及先、なのでforeign_keyはmentioning_idになる
  has_many :mentioned_relationship, class_name: 'Mention', foreign_key: 'mentioning_id', dependent: :destroy, inverse_of: :mentioning
  has_many :mentioned_reports, through: :mentioned_relationship, source: :mentioned
  has_many :mentioning_relationship, class_name: 'Mention', foreign_key: 'mentioned_id', dependent: :destroy, inverse_of: :mentioned
  has_many :mentioning_reports, through: :mentioning_relationship, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true
  validate :prevent_mentioning_not_exist_report

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_report_and_mentioning
    transaction do
      raise ActiveRecord::Rollback unless save
      raise ActiveRecord::Rollback unless save_mentioning

      true
    end
  end

  def update_report_and_mentioning(report_params)
    transaction do
      raise ActiveRecord::Rollback unless update(report_params)
      raise ActiveRecord::Rollback unless save_mentioning

      true
    end
  end

  private

  def prevent_mentioning_not_exist_report
    mentioned_ids = find_mentioned_ids(self)
    reports = Report.where(id: mentioned_ids)
    return if mentioned_ids.length.equal?(reports.length)

    errors.add(:mentioning, I18n.t('errors.messages.not_found'))
  end

  def save_mentioning
    mentioned_ids = find_mentioned_ids(self)
    reports = Report.where(id: mentioned_ids)
    begin
      self.mentioning_reports = reports
      true
    rescue ActiveRecord::RecordInvalid => e
      errors.merge!(e.record.errors)
      false
    end
  end

  def find_mentioned_ids(report)
    report.content.scan(%r{http://localhost:3000/reports/(.+)}).flatten
  end
end
