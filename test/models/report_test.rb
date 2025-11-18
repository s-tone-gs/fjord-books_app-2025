# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'editable? return true when user is writer of the_report' do
    assert(reports(:alice_report).editable?(users(:report_writer_named_alice)))
  end

  test 'editable return false when user is not writer of the_report' do
    assert_not(reports(:alice_report).editable?(users(:just_registered_user)))
  end

  test 'created_on return correct Date' do
    travel_to Time.zone.local(2025, 11, 18, 2, 15, 44)
    report = Report.new(title: 'dummy', content: 'summy')
    report.user = users(:report_writer_named_alice)
    report.save

    assert_equal(Date.current, report.created_on)
  end

  test 'save_mentions add ReportMention successfully' do
    report = Report.new(title: 'dummy', content: 'http://localhost:3000/reports/2')
    report.user = users(:report_writer_named_alice)
    report.save
    assert_includes(report.mentioning_reports, reports(:bob_report_mentioned_by_others), '言及が正しく保存されていません')
  end

  test 'save_mentions remove ReportMention successfully' do
    report = reports(:alice_report_mentioning_bob_report)
    report.update(content: '言及を消します')
    assert_not_includes(report.mentioning_reports, reports(:bob_report_mentioned_by_others), '言及が正しく削除できていません')
  end
end
