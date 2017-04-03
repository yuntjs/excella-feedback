ADMINS = [
  { first_name: 'Nicholas', last_name: 'Oki' },
  { first_name: 'Pramod', last_name: 'Jacob' },
  { first_name: 'Khoi', last_name: 'Le' },
  { first_name: 'Drew', last_name: 'Nickerson' }
]

puts 'Setting initial admins...'
ADMINS.each do |admin|
  user = User.new(
    first_name: admin[:first_name],
    last_name: admin[:last_name],
    password: ENV['ADMIN_PASS_INIT'],
    is_admin: true
  )
  user.email = "#{admin[:first_name]}.#{admin[:last_name]}@excella.com"
  user.save
end
