require "rails_helper"

RSpec.describe Repost, type: :model do
  it { belong_to :user }
  it { belong_to :track }
end
