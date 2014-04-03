class Instructor < ActiveRecord::Base
	# create a callback that will strip non-digits before saving to db
	before_save :reformat_phone


	# Relationships
	# -----------------------------
	has_many :camps, through: :camp_instructors
	has_many :camp_instructors

	# Scopes
	# -----------------------------
	scope :alphabetical, -> { order('last_name', 'first_name') }
	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }
	scope :needs_bio, -> { where(bio: nil) }

	# Validations
	# -----------------------------
	validates_presence_of :first_name, :last_name, :phone
	validates_format_of :first_name, with: /[a-zA-Z]+/, :case_sensitive => false
	validates_format_of :last_name, with: /[a-zA-Z]+/, :case_sensitive => false
	validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/
	validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format"

	#misc. methods
	#returns name
	def name
		[last_name, first_name].compact.join(', ')
	end

	#returns proper name
	def proper_name
		[first_name, last_name].compact.join(' ')
	end

	#returns array of instructors for a camp
	def self.for_camp(balls)
		possible_camp_instructors = Array.new
		# gets array of possible camp instructor objects 
		possible_camp_instructors = CampInstructor.where("camp_id = ?", balls.id)
		instructs = Array.new
		# returns instructors associated with camp instructor obj
		possible_camp_instructors.all.each do |e|
			instructs.push(e.instructor)
		end
		return instructs
	end


	
	# Callback code
	# -----------------------------
	private
	# We need to strip non-digits before saving to db
		def reformat_phone
			phone = self.phone.to_s  # change to string in case input as all numbers 
			phone.gsub!(/[^0-9]/,"") # strip all non-digits
			self.phone = phone       # reset self.phone to new string
		end
end
