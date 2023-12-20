# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :word, presence: true
  belongs_to :user
end
