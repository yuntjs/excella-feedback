NUM_USERS = 40
NUM_PRESENTATIONS = 8
PASSWORD = 'testing'.freeze

nest = [
  { first_name: 'Nick', last_name: 'Oki' },
  { first_name: 'Pramod', last_name: 'Jacob' },
  { first_name: 'Khoi', last_name: 'Le' },
  { first_name: 'Drew', last_name: 'Nickerson' }
]

presenters = [
  { first_name: 'Starr', last_name: 'Chen' },
  { first_name: 'Jen', last_name: 'Pengelly' },
  { first_name: 'Alexis', last_name: 'Johnson' },
  { first_name: 'Dan', last_name: 'Davis' }
]

presentations = [
  'Intro to Git',
  'Debugging/Refactoring',
  'DevOps',
  'Testing',
  'Agile/Scrum'
]

locations = [
  'ATX A',
  'ATX B',
  '2300 Clarendon 3rd Floor',
  '2300 Clarendon 9th Floor',
  'Bench'
]

surveys = %w(
  Overall
  Presenters
  Material
)

number_questions = [
  'Rate this (A)',
  'Rate this (B)'
]

text_questions = [
  'Additional Comments'
]

survey_templates = [
  'Technical Overall',
  'Non-Technical Overall'
]

puts 'Destroying everything...'
User.destroy_all
Presentation.destroy_all
Participation.destroy_all
Survey.destroy_all
Question.destroy_all
Response.destroy_all
SurveyTemplate.destroy_all
QuestionTemplate.destroy_all

puts 'Creating basic users...'
nest.each do |n|
  u = User.new(
    first_name: (n[:first_name]).to_s,
    last_name: (n[:last_name]).to_s,
    password: PASSWORD,
    is_admin: false
  )
  u.email = "#{u[:first_name]}.#{u[:last_name]}@excella.com"
  u.save
end
presenters.each do |n|
  u = User.new(
    first_name: (n[:first_name]).to_s,
    last_name: (n[:last_name]).to_s,
    password: PASSWORD,
    is_admin: false
  )
  u.email = "#{u[:first_name]}.#{u[:last_name]}@excella.com"
  u.save
end

puts 'Creating admin...'
u = User.new(
  first_name: 'Admin',
  last_name: 'Admin',
  password: PASSWORD,
  is_admin: true
)
u.email = 'admin@excella.com'
u.save

puts 'Creating presentations, surveys, and questions...'
presentations.each do |pres_name|
  pres = Presentation.create(
    title: pres_name,
    date: Faker::Time.between(6.months.ago, Faker::Time.forward(168)),
    location: locations.sample,
    description: Faker::HarryPotter.quote,
    is_published: true
  )
  surveys.each_with_index do |survey_name, index|
    survey = pres.surveys.create(
      position: index,
      title: survey_name
    )
    number_questions.each_with_index do |question, n_ind|
      ques = survey.questions.create(
        position: n_ind,
        prompt: question,
        response_type: 'number',
        response_required: true
      )
      ques.save
    end
    text_questions.each_with_index do |question, t_ind|
      ques = survey.questions.create(
        position: t_ind + number_questions.length,
        prompt: question,
        response_type: 'text',
        response_required: false
      )
      ques.save
    end
  end
end

puts 'Creating participations...'
Presentation.all.each do |pres|
  nest.each do |person|
    user = User.find_by(email: "#{person[:first_name].downcase}.#{person[:last_name].downcase}@excella.com")
    Participation.create(
      user_id: user.id,
      presentation_id: pres.id,
      is_presenter: false
    )
  end
  rand_presenter = presenters.sample
  presenter = User.find_by(email: "#{rand_presenter[:first_name].downcase}.#{rand_presenter[:last_name].downcase}@excella.com")
  Participation.create(
    user_id: presenter.id,
    presentation_id: pres.id,
    is_presenter: true
  )
end

puts 'Creating Survey Templates and Question Templates...'
survey_templates.each do |template_title|
  SurveyTemplate.create(
    name: "Template Name for #{template_title}",
    title: template_title
  )
end
SurveyTemplate.all.each do |survey|
  number_questions.each do |question|
    QuestionTemplate.create(
      prompt: question,
      response_type: 'number',
      response_required: true,
      survey_template_id: survey.id
    )
  end
  text_questions.each do |question|
    QuestionTemplate.create(
      prompt: question,
      response_type: 'text',
      response_required: false,
      survey_template_id: survey.id
    )
  end
end

puts 'Done!'
puts "Note: all users have the password \"#{PASSWORD}\""
