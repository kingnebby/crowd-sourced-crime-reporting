# spec/models/crime_report.rb
require 'spec_helper'

# This is our primary model test specification. We 'describe' the model under disscussion
# by giving it a series of 'it' descriptions and saying what it should do. Like requirements.
# Then we use FactoryGirl to produce our models and pick them apart, testing the "unhappy" paths
# with care. The describe can let us do 'before' and 'after' 
describe CrimeReport do
	it "has a valid factory" do
		mock_geocoding!
		FactoryGirl.create(:valid_crime_report).should be_valid
	end
	it "is invalid without a username" do
		mock_geocoding!
		FactoryGirl.build(:valid_crime_report, user: nil).should_not be_valid
	end
	it "is invalid without an address" do
		mock_geocoding!
		FactoryGirl.build(:valid_crime_report, address: nil).should_not be_valid
	end
	it "is invalid without some media" do
		mock_geocoding!
		FactoryGirl.build(:valid_crime_report, body: nil).should_not be_valid
	end

	describe "validate coordiantes" do
		before :each do
			mock_geocoding!(:coordinates => [20.0, 10.0])
			@seattle = FactoryGirl.create(:valid_crime_report, address: "Seattle, WA")
			@seattle.should be_valid
		end

		# Could even through  in some 'context' blocks here if I so desired, but that's un-needed
		# complexity.
		it "returns a latitude after geocoding" do
			@seattle.latitude.should == 20
		end

		it "returns a longitude after geocoding" do
			@seattle.longitude.should == 10
		end
	end

	it "mocks geocoding" do
		mock_geocoding! # You may pass additional params to override defaults (i.e. :coordinates => [10, 20])
		cr = FactoryGirl.create(:valid_crime_report)
		cr.latitude.should eq(1)
		cr.longitude.should eq(2)
	end
end