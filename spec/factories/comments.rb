# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'コメント' }
    user
    article
  end
end
