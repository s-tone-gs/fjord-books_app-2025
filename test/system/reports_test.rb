# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @user = users(:report_writer_named_alice)
    @report = reports(:alice_report)

    visit new_user_session_path
    fill_in User.human_attribute_name('email'), with: @user.email
    fill_in User.human_attribute_name('password'), with: 'password'
    click_on I18n.t('devise.sessions.new.sign_in')
    assert_text I18n.t('devise.sessions.signed_in')
  end

  test 'should create report' do
    visit reports_url
    click_on I18n.t('views.common.new', name: Report.model_name.human)
    fill_in  Report.human_attribute_name('title'), with: @report.title
    fill_in  Report.human_attribute_name('content'), with: @report.content
    click_on I18n.t('helpers.submit.create', name: Report.model_name.human)

    assert_text I18n.t('controllers.common.notice_create', name: Report.model_name.human)
    assert_text I18n.t('views.common.title_show', name: Report.model_name.human)
    assert_text @report.title
    assert_text @report.content
    assert_text @report.user.name
    click_on I18n.t('views.common.back', name: Report.model_name.human)
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on I18n.t('views.common.edit', name: Report.model_name.human)
    fill_in  Report.human_attribute_name('title'), with: @report.title
    fill_in  Report.human_attribute_name('content'), with: @report.content
    click_on I18n.t('helpers.submit.update', name: Report.model_name.human)

    assert_text I18n.t('controllers.common.notice_update', name: Report.model_name.human)
    assert_text I18n.t('views.common.title_show', name: Report.model_name.human)
    assert_text @report.title
    assert_text @report.content
    assert_text @report.user.name
    click_on I18n.t('views.common.back', name: Report.model_name.human)
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on I18n.t('views.common.destroy', name: Report.model_name.human)
    assert_text I18n.t('controllers.common.notice_destroy', name: Report.model_name.human)

    visit report_url(@report)
    assert_text 'ActiveRecord::RecordNotFound'
  end
end
