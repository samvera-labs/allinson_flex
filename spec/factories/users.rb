# We use modify instead of define because the actual factory is defined in hyrax/spec/factories

FactoryBot.define do
  factory :base_user, class: User do
    sequence(:email) { |_n| "email-#{srand}@test.com" }
    password { 'testing123' }
    password_confirmation { 'testing123' }

    factory :user do
    end
  end
end
