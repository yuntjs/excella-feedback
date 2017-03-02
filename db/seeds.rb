NUM_USERS = 40
NUM_ADMINS = 5
NUM_PRESENTATIONS = 8
PARTICIPATIONS_PER_PRESENTATION = 10
SURVEYS_PER_PRESENTATION = 3
QUESTIONS_PER_SURVEY = 5
RESPONSE_NUM_MAX = 5
PASSWORD = "testing"

unless Rails.env.production?
  puts "Destroying everything..."
  User.destroy_all
  Presentation.destroy_all
  Participation.destroy_all
  Survey.destroy_all
  Question.destroy_all
  Response.destroy_all
end

puts "Creating basic users..."
NUM_USERS.times do |n|
  u = User.new(
    first_name: "Foo#{n}",
    last_name: "Bar#{n}",
    password: PASSWORD,
    is_admin: false
  )
  u.email = "#{u.first_name}#{u.last_name}@example.com"
  u.save
end

puts "Creating #{NUM_ADMINS} admins..."
NUM_ADMINS.times do |n|
  u = User.new(
    first_name: "Admin",
    last_name: "#{n}",
    password: PASSWORD,
    is_admin: true
  )
  u.email = "admin#{n}@example.com"
  u.save
end

puts "Creating non-admin Khoi..."
basic_user = User.create(
  email: "khoi@khoi.khoi",
  password: PASSWORD,
  first_name: "Khoi",
  last_name: "Le",
  is_admin: false
)

puts "Creating admin Nick..."
admin = User.create(
  email: "nick@nick.nick",
  password: PASSWORD,
  first_name: "Nick",
  last_name: "Oki",
  is_admin: true
)

puts "Creating presentations, surveys, and questions..."
NUM_PRESENTATIONS.times do
  pres = Presentation.create(
    title: Faker::Hipster.words(3).join(' '),
    date: Faker::Time.between(6.months.ago, Date.today),
    location: Faker::GameOfThrones.city,
    description: Faker::Hacker.say_something_smart,
    is_published: true
  )
  SURVEYS_PER_PRESENTATION.times do |survey_num|
    survey = pres.surveys.create(
      order: survey_num,
      subject: Faker::Book.title
    )
    QUESTIONS_PER_SURVEY.times do |ques_num|
      ques = survey.questions.create(
        order: ques_num,
        prompt: Faker::Hipster.words(5).join(' ') + '?',
        response_type: ['text', 'number'].sample
      )
      ques.save
    end
  end
end

puts "Creating participations..."
Presentation.all.each do |pres|
  PARTICIPATIONS_PER_PRESENTATION.times do
    u = User.all.sample
    part = Participation.find_by(user_id: u.id, presentation_id: pres.id)
    if part.nil?
      new_part = Participation.create(
        user_id: u.id,
        presentation_id: pres.id,
        is_presenter: false
      )
      # Set first user as presenter
      if pres.users.count == 1
        new_part.is_presenter = true
        new_part.save
      end
    end
  end
end

puts "Creating responses..."
Question.all.each do |ques|
  pres = ques.survey.presentation
  pres.users.each do |user|
    part = Participation.find_by(user_id: user.id, presentation_id: pres.id)
    next if part.is_presenter
    Response.create(
      question_id: ques.id,
      user_id: user.id,
      value: ques.response_type == 'text' ? Faker::Hipster.words(2).join(' ') : rand(1..RESPONSE_NUM_MAX).to_s
    )
  end
end

puts "Done!"
puts "Note: all users have the password \"#{PASSWORD}\""
