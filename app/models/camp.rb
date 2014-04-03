class Camp < ActiveRecord::Base
	# create a callback that will save all time_slots in the system as downcased
	before_save :save_time_slot 

	# Relationships
	# -----------------------------
	has_many :instructors, through: :camp_instructors
	belongs_to :curriculum
	has_many :camp_instructors

	# Scopes
	# -----------------------------
	scope :alphabetical, -> { joins(:curriculum).order('curriculums.name')}
	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }
	scope :chronological, -> { order(:start_date, :end_date) }
	scope :morning, -> { where("time_slot = ?", 'am') }
	scope :afternoon, -> { where("time_slot = ?", 'pm') }
	scope :upcoming, -> { where('start_date >= ?', Time.now.to_date) }
	scope :past, -> { where('end_date <  ?', Time.now.to_date) } 
	scope :for_curriculum, -> (curriculum_id) { where("curriculum_id = ?", curriculum_id) }

	# Validations
	# -----------------------------
	validates_presence_of :curriculum_id
	validates_presence_of :start_date
	validates_presence_of :time_slot
	validates_presence_of :end_date
	validates_numericality_of :curriculum_id, only_integer: true
	validate :am_or_pm
	validate :date_checker_not_past_start, on: :create
	validate :date_checker_not_past_end, on: :create
	validate :date_checker_end_not_before_start
	validates_numericality_of :cost, greater_than_or_equal_to: 0, only_integer: true
	validates_numericality_of :max_students, greater_than: 0, only_integer: true
	# validates :max_stu_num
	validate :val_cur_id
	validate :check_dups, on: :create
	validates_date :start_date, :end_date

	#misc. methods
	# def max_stu_num
	# 	camp_ids = CampInstructor.map { |e| e.camp_id }
	# 	a = 0
	# 	camp_ids do |e|
	# 		if (self.id == e)
	# 			a=a+1
	# 		else 
	# 			continue
	# 		end
	# 	end
	# 	if (a*4<=self.max_students)
	# 		return true
	# 	else
	# 		return false
	# 	end
	# end

	#returns name of curriculum
	def name
		return self.curriculum.name
	end


	private
		#returns valid active curriculum ids
		def val_cur_id
			return if curriculum_id.nil?

			curriculum_ids = Curriculum.active.map { |e| e.id }
			if curriculum_ids.include?(self.curriculum_id)
				return true
			else
				errors.add(:curriculum_id, "not valid curriculum id")
				return false
			end
		end

		# Checks if time slot is either am or pm
		def am_or_pm
			return if time_slot.nil?
			# a = self.time_slot.downcase
			if (self.time_slot.downcase == "am" || self.time_slot.downcase == "pm")
				return true
			else
				errors.add(:time_slot, "not am or pm for time slot")
				return false
			end
		end

		#downcases the time slot
		def save_time_slot 
			return self.time_slot.downcase
		end

		# checks for duplicate Camps 
		def check_dups
			Camp.all.each do |e|
				if (e.time_slot == self.time_slot && e.start_date.to_date == self.start_date.to_date)
					errors.add(:time_slot, "duplicate camp in the system")
					return false
				end 
			end
			return true
		end

		# start date not in the past 
		def date_checker_not_past_start
			return if start_date.nil?

			if (self.start_date.to_date >= Time.now.to_date)
				return true
			else 
				errors.add(:start_date, "start_date or end_date is in the past")
				return false 
			end
		end

		# end date not in the past
		def date_checker_not_past_end
			return if end_date.nil?

			if (self.end_date.to_date >= Time.now.to_date)
				return true
			else 
				errors.add(:end_date, "start_date or end_date is in the past")
				return false 
			end
		end

		# end date not before start date
		def date_checker_end_not_before_start
			return if start_date.nil? || end_date.nil?

			if (self.start_date.to_date<self.end_date.to_date)
				return true 
			else
				errors.add(:end_date, "end date is not after start date")
				return false
			end
		end 

end
