# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user
    article
  end
end
