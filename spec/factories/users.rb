FactoryBot.define do
    factory :user do
      email { "test@example.com" }
      password { "password" }
      username { "username" }
    end
  end
  