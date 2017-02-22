require 'rails_helper'

RSpec.describe Question, type: :model do

  it { should belong_to :survey }
  it { should have_many :responses }
  it { should have_many :users }

end
