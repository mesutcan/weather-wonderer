require 'rails_helper'

RSpec.describe ForecastQueryService, type: :model do

  describe "with zipcode" do
    it "returns success with valid zipcode" do
      subject = described_class.new(zipcode: "90049")
      results = subject.call
      # Test 6 results are returned
      expect(results["cnt"]).to eq(6)
      expect(results["cod"]).to eq("200")
    end

    it "returns error with non-existing zipcode" do
      subject = described_class.new(zipcode: "00000")
      results = subject.call
      expect(results["cod"]).to eq("404")
    end
  end

  describe "with latitude and longtitude" do
    it "returns success with valid latitude and longtitude" do
      subject = described_class.new(lat_long: ["34.0522", "-118.2437"])
      results = subject.call
      # Test 6 results are returned
      expect(results["cnt"]).to eq(6)
      expect(results["cod"]).to eq("200")
    end

    it "returns error with non-existing latitude and longtitude" do
      subject = described_class.new(lat_long: ["", ""])
      results = subject.call
      expect(results["cod"]).to eq("400")
    end
  end
end
