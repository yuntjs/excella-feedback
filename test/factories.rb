FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@example.com" }
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
    date DateTime.now - 100_000
    location 'location'
    description 'description'

    trait :in_the_future do
      date DateTime.now + 100_000
    end

    trait :long_description do
      description 'description ' * 100
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
    sequence(:position) { |n| n }
    sequence(:title) { |n| "Survey #{n}" }
    presenter_id nil
    presentation
  end

  factory :question do
    sequence(:id) { |n| n }
    sequence(:prompt) { |n| "Question #{n}" }
    position 1
    survey

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
  end

  factory :survey_template do
    title 'My new survey_template title'
    name 'My new survey_template name'
  end

  factory :question_template do
    sequence(:prompt) { |n| "question_template prompt #{n}" }
    survey_template

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
end
