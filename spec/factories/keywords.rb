# frozen_string_literal: true

FactoryBot.define do
  factory :keyword do
    word { 'キーワード' }
    user
  end
end
  