require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { belong_to(:commentable) }
  it { belong_to(:user) }
end
