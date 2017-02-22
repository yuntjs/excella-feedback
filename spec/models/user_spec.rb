require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many :participations }
  it { should have_many :presentations }
  it { should have_many :responses }
  it { should have_many :questions }

end
