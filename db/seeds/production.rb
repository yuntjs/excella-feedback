puts 'Creating an admin...'
User.find_by(email: 'admin@excella.com').destroy
User.create(
  first_name: 'Excella',
  last_name: 'Admin',
  password: ENV['admin_password'],
  is_admin: true,
  email: 'admin@excella.com'
)
