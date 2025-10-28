module Authorization
  def authorize_user!(model, id)
    owner = model.find(id).user
    unless owner == current_user
      redirect_to reports_path, notice: t('controllers.common.notice_unauthorized')
    end
  end
end
