# frozen_string_literal: true

class ReportCommentsController < CommentsController
  include CommentSetup
  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

  def render_failure
    @report = @commentable
    @comments = set_comments(@commentable)
    render 'reports/show', status: :unprocessable_entity
  end

end
