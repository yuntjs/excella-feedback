puts 'Creating an admin...'
User.create(
  first_name: 'Excella',
  last_name: 'Admin',
  password: '3xc311@-@dm1n',
  is_admin: true,
  email: 'admin@excella.com'
)
