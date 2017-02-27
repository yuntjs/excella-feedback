# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

NUM_USERS = 10
NUM_ADMINS = 2
NUM_PRESENTATIONS = 10
NUM_PARTICIPATIONS = 100
NUM_SURVEYS = 5
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
  u.email = "#{first_name}#{last_name}@example.com"
  u.save
end

puts "Creating admins..."
NUM_ADMINS.times do
  u = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: PASSWORD,
    is_admin: true
  )
  u.email = "#{first_name}#{last_name}@example.com"
  u.save
end

puts "Creating non-admin (Khoi)..."
basic_user = User.create!(
  email: "khoi@khoi.khoi",
  password:"testing",
  first_name: "Khoi",
  last_name: "Le",
  is_admin: false
)

puts "Creating admin (Nick)..."
admin = User.create!(
  email: "nick@nick.nick",
  password:"testing",
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
NUM_PARTICIPATIONS.times do
  part = Participation.create(
    
  )
end

Participation.create!(user_id: basic_user.id, presentation_id: pres1.id)
Participation.create!(user_id: basic_user.id, presentation_id: pres2.id)
Participation.create!(user_id: basic_user.id, presentation_id: pres3.id, is_presenter: true)


survey1 = Survey.create!(presentation_id: pres1.id, order: 1, subject: "Dev Env")
