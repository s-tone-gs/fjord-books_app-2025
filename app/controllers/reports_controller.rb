# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mentioneds = @report.mentioned_reports.includes(:user)
  end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    mentioned_ids = find_mentioned_ids(@report)
    @report.transaction do
      @report.save!
      mentioned_reports = Report.find(mentioned_ids)
      @report.mentioning_reports << mentioned_reports
    end
    redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
  end

  def update
    @report.transaction do
      @report.update!(report_params)
      mentioned_ids = find_mentioned_ids(@report)
      mentioned_reports = Report.find(mentioned_ids)
      @report.mentioning_reports = mentioned_reports
    end
    redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
  end

  def destroy
    @report.destroy!

    redirect_to reports_path, status: :see_other, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def find_mentioned_ids(report)
    report.content.scan(%r{http://localhost:3000/reports/(.+)}).flatten
  end

  def report_params
    params.expect(report: %i[user_id title content])
  end
end
