class CrimeReport < ActiveRecord::Base
	validates :user, presence: true, length: {minimum: 4}	
	validates :address, presence: true
	validates :body, presence: true

	geocoded_by :address, :if => :address_changed?
	# reverse_geocoded_by :latitude, :longitude
	after_validation :geocode
end
