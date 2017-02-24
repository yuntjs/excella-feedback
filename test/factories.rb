# This will guess the User class
FactoryGirl.define do

  factory :user do
    email "test@excella.com"
    password "testing"
    first_name "Ex"
    last_name  "Cella"
    is_admin false
    # If admin
    trait :admin do
      is_admin true
    end
  end

  factory :presentation do
    title "Factory Girl"
    date DateTime.now
    location "ATX"
    description "This is a description of our presentation"
    # association :user
  end

  factory :participation do
    user
    presentation
    is_presenter false
    # If presenter
    trait :presenter do
      is_presenter true
    end
  end
end
