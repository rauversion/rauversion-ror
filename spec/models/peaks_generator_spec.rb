require "rails_helper"

def normalize(input)
    # Find the maximum absolute value in the array
    max_abs_value = input.map(&:abs).max.to_f

    # Normalize each value in the inputay
    input.map { |val| val / max_abs_value }
end

describe "something to be performed" do
  context "under condition" do
    it "behaves like" do
      
      input = [-40,45,-45,56,-41,48,-34,45,-32,40,-24,37,-39,52]

      peaks = normalize(input)
      expect(peaks).to include(1.0)

    end
  end
end
