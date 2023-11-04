FactoryBot.define do
    factory :comment do
        association :user
        association :article
    end
end
