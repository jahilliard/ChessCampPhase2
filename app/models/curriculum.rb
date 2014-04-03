class Curriculum < ActiveRecord::Base
	# Relationships
	# -----------------------------
	has_many :camps

	# Scopes
	# -----------------------------
	scope :alphabetical, -> { order('name') }
	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }
	scope :for_rating, -> (rating) { where('min_rating <= ? AND max_rating >= ?', rating, rating) }

	# Validations
	# -----------------------------
	validates_presence_of :name
	validates_presence_of :min_rating
	validates_presence_of :max_rating
	validates_numericality_of :min_rating, only_integer: true
	validates_numericality_of :max_rating, only_integer: true
	validates_uniqueness_of :name, :case_sensitive => false
	validate :rating_check_min
	validate :rating_check_max
	validate :rating_check_max_greater_min

	# unused method
	# def for_rating(rating)
	# 	raise ArgumentError, 'Gotta Be a Number JackAss' unless rating.is_a? Fixnum
	# 	currs_new = Array.new
	# 	currs_all = Curriculum.map { |e| e }
	# 	currs_a.each do |e|
	# 		if (self.min_rating >= rating && self.max_rating <= rating)
	# 			currs_new.push(e)
	# 		end
	# 	end
	# 	return currs_new
	# end


	private
		#checks if min_rating is within proper range
		def rating_check_min
			return if self.min_rating.nil?

			if ((self.min_rating==0 || self.min_rating>99) && self.min_rating<3000)
				return true
			else
				errors.add(:min_rating, "doesnt have correct max_rating")
				return false
			end
		end

		#checks if max_rating is within proper range
		def rating_check_max
			return if self.max_rating.nil?
	
			if ((self.max_rating==0 || self.max_rating>99) && self.max_rating<3000)
				return true
			else
				errors.add(:max_rating, "doesnt have correct max_rating")
				return false
			end
		end

		#checks if min_rating is less then max_rating
		def rating_check_max_greater_min
			return if self.min_rating.nil? || self.max_rating.nil?

			if (self.min_rating <= self.max_rating)
				return true
			else
				errors.add(:max_rating, "min_rating not less then max_rating")
				return false
			end
		end

end
