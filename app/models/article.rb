class Article < ActiveRecord::Base
	belongs_to :track
	has_many :comments, dependent: :destroy
	validates :title, presence: true, length: {minimum: 5 }
	validates :address, presence: true
	geocoded_by :address
		after_validation :geocode

	def latlon
		[self.latitude, self.longitude]
	end
end
