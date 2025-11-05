# frozen_string_literal: true

class ReportsController < ApplicationController
  include CommentSetup
  include Authorization
  before_action :set_report, only: %i[show edit update destroy]
  before_action only: %i[edit update destroy] do
    authorize_user!(Report, params.expect(:id))
  end

  # GET /reports
  def index
    @reports = Report.order(:id).page(params[:page])
  end

  # GET /reports/1
  def show
    @comment = Comment.new
    set_comments(@report)
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit; end

  # POST /reports
  def create
    @report = current_user.reports.build(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  def destroy
    @report.destroy!

    respond_to do |format|
      format.html { redirect_to reports_path, status: :see_other, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.expect(report: %i[user_id title body])
  end
end
