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
<<<<<<< Updated upstream
    sequence(:title) { |n| "presentation#{n}"}
    date DateTime.now
    location "location"
    description "description"
=======
    sequence(:title) { |n| "Presentation #{n}" }
    date DateTime.now - 100_000
    location 'location'
    description 'description'

    trait :in_the_future do
      date DateTime.now + 100_000
    end
>>>>>>> Stashed changes

    trait :long_description do
      description "description description description description description description"
    end
  end

  factory :participation do
    user
    presentation
    is_presenter false

    trait :presenter do
      is_presenter true
    end
  end

  factory :survey do
    order 1
    subject "Git"
    presentation
  end

  factory :question do
    order 1
    survey
    prompt "The presentation was great"
    response_type "text"
  end

  factory :response do
    question
    user
    value "I responded to this question!"

    trait :invalid do
      question nil
      user nil
      question_id nil
      user_id nil
      value nil
    end
  end
end
