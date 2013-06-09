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

end
