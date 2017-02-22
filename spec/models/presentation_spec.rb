require 'rails_helper'

RSpec.describe Presentation, type: :model do

  it { should have_many :participations }
  it { should have_many :users }
  it { should have_many :surveys }

end
