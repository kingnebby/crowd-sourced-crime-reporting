# spec/controllers/crime_reports_controller_spec.rb
require 'spec_helper'

describe CrimeReportsController do
	# This will be just a test to get me used to testing Controllers.
	describe "GET #index" do
		context "simple check" do
			it "returns a json list of all reports" do
				mock_geocoding!
				FactoryGirl.create(:complete_crime_report)
				get :index
				json = JSON.parse(response.body)
				expect(json.length).to eq(1)
			end
		end
	end

	# This is really the only thing I want to test right now. There exist other
	# tests for other functions.
	describe "GET #search" do
		context "with invalid attributes" do
			before :each do
				mock_geocoding!
				@params = {
					lat: 45,
					lng: 45,
					radius: 5,
					starttime: ( Date.today() ),
					endtime: ( Date.today()+1 )
				}
			end

			after :each do
				get :search, @params
				JSON.parse(response.body).should be_empty
			end

			it "does nothing when missing latitude" do
				@params[:lat] = nil
			end	
			it "does nothing when missing longitude" do
				@params[:lng] = nil
			end 
			it "does nothing when missing radius" do
				@params[:radius] = nil
			end

			# between these two, we define a search worth time window.
			it "does nothing when missing starttime" do
				@params[:starttime] = nil
			end
			it "does nothing when missing endtime" do
				@params[:endtime] = nil
			end
		end

		context "with valid attributes" do
			before :each do
				@params = {
					lat: 45,
					lng: 45,
					radius: 5,
					starttime: ( Date.today() ),
					endtime: ( Date.today() )
				}
			end

			it "returns nothing when no data within radius" do
				mock_geocoding!(:coordinates => [50, 50])
				FactoryGirl.create(:valid_crime_report).should be_valid
				get :search, @params
				JSON.parse(response.body).should be_empty
			end

			it "returns one point if inside radius" do
				mock_geocoding!(:coordinates => [45, 45])
				str = 'Mega Mind'
				FactoryGirl.build(:valid_crime_report, user:str).save()
				get :search, @params
				json = JSON.parse(response.body)
				json[0]['user'].should == str
			end
			
			it "returns all points if inside radius" do
				mock_geocoding! :coordinates => [45, 45]
				i = 0
				while i < 10 do
					FactoryGirl.create(:valid_crime_report)
					i += 1
				end
				get :search, @params
				json = JSON.parse(response.body)
				json.length.should == 10
			end

			it "returns all points but one that is outside the range" do
				mock_geocoding! :coordinates => [45, 45]
				i = 0
				while i < 15 do
					FactoryGirl.create(:valid_crime_report)
					i += 1
				end
				mock_geocoding! :coordinates => [1, 1]
				FactoryGirl.create(:valid_crime_report)

				get :search, @params
				json = JSON.parse(response.body)
				# Can we say, !json.includes(:latitude => 1)?
				(json.any? {|obj| obj[:latitude] == 1}).should be_false
			end

			it "returns a time sorted list" do
				mock_geocoding! :coordinates => [45,45]
				# out of order
				FactoryGirl.build(:valid_crime_report, created_at: DateTime.new(2014,1,1,1,1)).save()
				FactoryGirl.build(:valid_crime_report, created_at: DateTime.new(2014,1,1,1,3)).save()
				FactoryGirl.build(:valid_crime_report, created_at: DateTime.new(2014,1,1,1,2)).save()

				get :search, @params
				json = JSON.parse(response.body)
				puts json
				json[0]['created_at'].should == DateTime.new(2014,1,1,1,1).strftime("%FT%T.%LZ")
				json[1]['created_at'].should == DateTime.new(2014,1,1,1,2).strftime("%FT%T.%LZ")
				json[2]['created_at'].should == DateTime.new(2014,1,1,1,3).strftime("%FT%T.%LZ")
			end
		end
	end
end