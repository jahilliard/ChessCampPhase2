class CampInstructor < ActiveRecord::Base
	# Relationships
	# -----------------------------
	belongs_to :instructor
	belongs_to :camp 

	# Scopes
	# -----------------------------


	# Validations
	# -----------------------------
	validates_presence_of :camp_id
	validates_presence_of :instructor_id
	validates_numericality_of :camp_id, only_integer: true 
	validates_numericality_of :instructor_id, only_integer: true 
	validate :proper_ranges_camp
	validate :proper_ranges_instructor
	validate :check_dups

	#misc. methods 

	
	# Callback code
	# -----------------------------
	private
	# We need to make sure ranges are properly saved and duplicates are checked

		#checks proper ranges for camp ids
		def proper_ranges_camp
			camp_ids = Camp.all.active.map { |e| e.id }
			if camp_ids.include?(self.camp_id)
				return true
			else
				errors.add(:camp_id, "not a active camp id")
				return false
			end
		end

		# checks proper ranges for instrcutor ids
		def proper_ranges_instructor
			instructor_ids = Instructor.all.active.map { |e| e.id }
			if instructor_ids.include?(self.instructor_id)
				return true
			else
				errors.add(:instructor_id, "not an active instructor id")
				return false
			end
		end

		#checks duplicates for camp instructors 
		def check_dups
			CampInstructor.all.each do |e|
				if (e.instructor.id == self.instructor_id && e.camp.id == self.camp_id)
					errors.add(:camp_id, "camp instrctor obj already exists")
					return false
				end
			end
			return true 
		end

			
end
