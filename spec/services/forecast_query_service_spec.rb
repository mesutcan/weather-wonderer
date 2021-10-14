require 'rails_helper'

RSpec.describe ForecastQueryService, type: :model do

  describe "with zipcode" do
    let(:sucessful_result) { described_class.new(zipcode: "90049").call }
    let(:failed_result) { described_class.new(zipcode: "00000").call }

    it "returns success with valid zipcode", :vcr do
      # Test 6 results are returned
      expect(sucessful_result["cnt"]).to eq(6)
      expect(sucessful_result["cod"].to_i).to eq(200)
    end

    it "returns error with non-existing zipcode", :vcr do
      expect(failed_result["cod"].to_i).to eq(404)
    end
  end

  describe "with latitude and longtitude" do
    let(:sucessful_result) { described_class.new(lat_long: ["34.0522", "-118.2437"]).call }
    let(:failed_result) { described_class.new(lat_long: ["", ""]).call }

    it "returns success with valid latitude and longtitude", :vcr do
      # Test 6 results are returned
      expect(sucessful_result["cnt"]).to eq(6)
      expect(sucessful_result["cod"].to_i).to eq(200)
    end

    it "returns error with non-existing latitude and longtitude", :vcr do
      expect(failed_result["cod"].to_i).to eq(400)
    end
  end
end
