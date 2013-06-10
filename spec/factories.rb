FactoryGirl.define do
  factory :user do
    name     "Test User"
    email    "user@example.com"
    username "user"
    password "foobarbazqux"
    password_confirmation "foobarbazqux"
  end

  factory :account do
    name "Savings Account"
    user
  end

  factory :transaction do
    description "Coffee"
    value 11.11
    moment 1.day.ago
    account
  end

end
