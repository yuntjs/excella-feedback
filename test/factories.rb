FactoryGirl.define do
  factory :user do
    sequence (:email) {|n| "email#{n}@example.com"}
    password 'password'
    first_name 'First'
    last_name  'Last'
    is_admin false

    trait :admin do
      is_admin true
    end
  end

  factory :presentation do
    sequence(:title) { |n| "Presentation #{n}" }
    date DateTime.now
    location 'location'
    description 'description'

    trait :long_description do
      description 'description description description description description description'
    end
  end

  factory :participation do
    user
    presentation
    is_presenter false
    feedback_provided false

    trait :presenter do
      is_presenter true
    end

    trait :feedback_submitted do
      feedback_provided true
    end
  end

  factory :survey do
    position 1
    subject "Git"
    presentation
  end

  factory :question do
    sequence(:prompt) { |n| "Question #{n}" }
    position 1
    survey
    response_type 'text'
    response_required false

    trait :text do
      response_type 'text'
    end

    trait :number do
      response_type 'number'
    end

    trait :optional do
      response_required false
    end

    trait :required do
      response_required true
    end
  end

  factory :response do
    question
    user

    trait :text do
      value 'I responded to this question!'
    end

    trait :number do
      value 3
    end

    trait :invalid do
      question nil
      user nil
      question_id nil
      user_id nil
      value nil
    end
  end
end
