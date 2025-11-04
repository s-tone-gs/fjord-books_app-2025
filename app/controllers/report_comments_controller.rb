# frozen_string_literal: true

class ReportCommentsController < CommentsController
  def set_commentable
    @commentable = Report.find(params[:report_id])
  end
end
