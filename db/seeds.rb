#
# Load db/seeds/<environment_file> based on Rails environment
#
load(Rails.root.join( 'db', 'seeds', "#{Rails.env.downcase}.rb"))
