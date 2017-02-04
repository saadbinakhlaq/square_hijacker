FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    encrypted_password "MyString"
    confirmation_token "MyString"
    remember_token "MyString"
    password '123456'
  end
end
