# frozen_string_literal: true

class Event < ApplicationRecord
  has_paper_trail

  belongs_to :consultation
  has_many :tokens, dependent: :nullify

  enum status: { opened: 1, closed: 0 }

  scope :managers, -> { where(role: :manager) }
  scope :voters, -> { where(role: :voter) }
end
