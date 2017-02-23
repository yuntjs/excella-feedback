# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Presentation.destroy_all
User.destroy_all

User.create!(email: "nick@nick.nick", password:"testing", first_name: "nick", last_name: "oki", is_admin: true)
khoi = User.create!(email: "khoi@khoi.khoi", password:"testing", first_name: "khoi", last_name: "le", is_admin: false)

dev_env = Presentation.create!(title: "Dev Env", date: DateTime.new(2017, 2, 22), location: "ATX", description: "Lorem Ipsum", is_published: true)

git = Presentation.create!(title: "Git", date: DateTime.new(2017, 2, 24), location: "ATX", description: "Lorem Gitsum", is_published: false)

dev_ops = Presentation.create!(title: "DevOps", date: DateTime.new(2017, 2, 23), location: "ATX", description: "Lorem Ipsum", is_published: true)

# khoi_git = khoi.presentations.push(git)


Participation.create!(user_id: khoi.id, presentation_id: git.id, is_presenter: true)

khoi.presentations.push(dev_ops)
