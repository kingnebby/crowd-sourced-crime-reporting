# spec/factories/crime_reports.rb
# Nifty little module that gives me lots of variant fake data. Just makes things fun!
require 'faker'

# This is a factory of factories. that will mock our real model. We can set these
# defaults and use them to test our logic.
FactoryGirl.define do
	# This is the factory for my crime report. I only need to mock those values that will be validated everytime.
	factory :valid_crime_report, :class => 'CrimeReport' do |c|
		c.user { Faker::Name.name }
		c.body { Faker::Lorem.sentence }
		c.address { "#{Faker::Address.city}, #{Faker::Address.state}" }
	end

	# We need a full blown factory for some of the controller actions.
	factory :complete_crime_report, :class => 'CrimeReport', parent: :valid_crime_report do |c|
		c.latitude { rand(180)-90 }
		c.longitude {rand(360)-180 }
	end
end
