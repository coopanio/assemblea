# frozen_string_literal: true

class Envelope
  attr_reader :question, :token, :value, :created_at

  def initialize(question, token, created_at: Time.now.utc, **kwargs)
    @question = question
    @token = token
    @value = kwargs[:value]
    @created_at = created_at
  end

  def vote
    @vote ||= Vote.new(question: question, value: value, weight: token.weight)
  end

  def receipt
    return @receipt if defined?(@receipt)

    @receipt ||= Receipt.new.tap do |r|
      r.token = token
      r.question = question
      r.created_at = created_at
      r.fingerprint = FingerprintService.generate(r, token.to_hash, value)
    end
  end

  def save(async: false)
    if async
      VoteCastJob.perform_later(question.id, token.id, value, receipt.created_at)
    else
      receipt.save!
      vote.save!
    end
  end
end
