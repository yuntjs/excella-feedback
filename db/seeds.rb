# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.destroy_all
Presentation.destroy_all

admin = User.create!(email: "nick@nick.nick", password:"testing", first_name: "nick", last_name: "oki", is_admin: true)
basic_user = User.create!(email: "khoi@khoi.khoi", password:"testing", first_name: "khoi", last_name: "le", is_admin: false)

pres1 = Presentation.create!(title: "Dev Env", date: DateTime.new(2017, 2, 21), location: "ATX", description: "Lorem Ipsum", is_published: true)
pres2 = Presentation.create!(title: "Git", date: DateTime.new(2017, 2, 22), location: "Octohub", description: "Lorem Gitsum", is_published: true)
pres3 = Presentation.create!(title: "DevOps", date: DateTime.new(2017, 2, 23), location: "Mordor", description: "Frodo will be taking us through the long path to working together as a team", is_published: true)
pres3 = Presentation.create!(title: "SCRUM", date: DateTime.new(2017, 2, 24), location: "Bikini Bottom", description: "Hey now, you're an all star, get your game on, go play. Hey now, you're a rock star, get your show on, get paid.", is_published: true)

Participation.create!(user_id: basic_user.id, presentation_id: pres1.id)
Participation.create!(user_id: basic_user.id, presentation_id: pres2.id)
Participation.create!(user_id: basic_user.id, presentation_id: pres3.id, is_presenter: true)
