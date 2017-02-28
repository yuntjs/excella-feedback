NUM_USERS = 40
NUM_ADMINS = 5
NUM_PRESENTATIONS = 8
NUM_PARTICIPATIONS = 100
PASSWORD = "testing"

puts "Destroying everything..."
User.destroy_all
Presentation.destroy_all
Participation.destroy_all
Survey.destroy_all

puts "Creating basic users..."
NUM_USERS.times do |n|
  u = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: PASSWORD,
    is_admin: false
  )
  u.email = "#{u.first_name}#{u.last_name}@example.com"
  u.save
end

puts "Setting #{NUM_ADMINS} users as admins..."
admin_count = 0
while admin_count != NUM_ADMINS
  u = User.all.sample
  unless u.is_admin
    u.is_admin = true
    u.save
    admin_count += 1
  end
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

puts "Creating presentations..."
NUM_PRESENTATIONS.times do
  Presentation.create(
    title: Faker::Hipster.words(3).join(' '),
    date: Faker::Time.between(6.months.ago, Date.today),
    location: Faker::GameOfThrones.city,
    description: Faker::Hacker.say_something_smart,
    is_published: true
  )
end

puts "Creating participations..."
Presentation.all.each do |pres|
  10.times do
    u = User.all.sample
    part = Participation.find_by(user_id: u.id, presentation_id: pres.id)
    if part.nil?
      new_part = Participation.create(
        user_id: u.id,
        presentation_id: pres.id
      )
      # Set first user as presenter
      if pres.users.count == 1
        new_part.is_presenter = true
        new_part.save
      end
    end
  end
end

puts "Done!"
puts "Note: all users have the password \"#{PASSWORD}\""

# survey1 = Survey.create!(presentation_id: pres1.id, order: 1, subject: "Dev Env")
