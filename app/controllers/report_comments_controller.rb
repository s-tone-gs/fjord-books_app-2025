# frozen_string_literal: true

class ReportCommentsController < CommentsController
  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

  def render_failure
    @report = @commentable
    @comments = Comment.comments_to_commentable(@commentable)
    render 'reports/show', status: :unprocessable_entity
  end
end
