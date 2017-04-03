require './db/seeds/admins.rb'

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
