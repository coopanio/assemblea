# frozen_string_literal: true

require 'test_helper'

class VotesControllerTest < ActionDispatch::IntegrationTest
  attr_reader :question, :token, :value

  setup do
    @question = create(:question)
    create(:option, question: question, value: 'yes')
    create(:option, question: question, value: 'no')
    event = create(:event, consultation: question.consultation)
    @token = create(:token, event: event, consultation: question.consultation)
    @value = 'yes'

    post sessions_url, params: { token: token.to_hash }
  end

  subject { post votes_url, params: { vote: { question_id: question.id, value: @value } } }

  test 'should create vote' do
    subject
    assert_response :success

    Vote.all.tap do |votes|
      assert_equal 1, votes.length
      assert votes.first.value = 'yes'
    end

    Receipt.find_by(token: token, question: question).tap do |receipt|
      assert receipt.present?
      assert receipt.fingerprint.present? && receipt.fingerprint.length == 64
    end
  end

  test 'should asynchronously create vote' do
    Rails.configuration.x.assemblea.async_vote = true
    subject

    perform_enqueued_jobs
    assert_performed_jobs 1

    Vote.all.tap do |votes|
      assert_equal 1, votes.length
      assert votes.first.value = 'yes'
    end

    assert_includes response.body, Receipt.first.fingerprint
  end

  test 'should fail if question_id is unknown' do
    @question.id = nil
    subject

    assert_response 400
    assert_empty Vote.all
    assert_not Receipt.exists?(token: token, question: question)
  end

  test 'should fail if value is not valid' do
    @value = 'nay'
    subject

    assert_response :redirect
    assert_empty Vote.all
    assert_not Receipt.exists?(token: token, question: question)
  end

  test 'should fail if a second vote is attempted' do
    subject
    assert_response :success

    post votes_url, params: { vote: { question_id: question.id, value: 'no' } }
    assert_response :redirect
  end
end
