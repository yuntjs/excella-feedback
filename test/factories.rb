# This will guess the User class
FactoryGirl.define do

  factory :user do
    email "email@example.com"
    password "password"
    first_name "First"
    last_name  "Last"
    is_admin false

    trait :admin do
      is_admin true
    end
  end

  factory :presentation do
    sequence(:title) { |n| "presentation#{n}"}
    date DateTime.now
    location "location"
    description "description"
  end

  factory :participation do
    user
    presentation
    is_presenter false

    trait :presenter do
      is_presenter true
    end
  end

end
