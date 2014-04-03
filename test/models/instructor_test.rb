require 'test_helper'

class InstructorTest < ActiveSupport::TestCase
	# Start by using ActiveRecord macros
	# Relationship macros...
	should have_many(:camps).through(:camp_instructors)
	should have_many(:camp_instructors)

	# Validation macros
	should validate_presence_of(:first_name)
	should validate_presence_of(:last_name)
	should validate_presence_of(:phone)

	#Validating phone numbers
	should allow_value("4122683259").for(:phone)
	should allow_value("412-268-3259").for(:phone)
	should allow_value("412.268.3259").for(:phone)
	should allow_value("(412) 268-3259").for(:phone)

	should_not allow_value("2683259").for(:phone)
	should_not allow_value("4122683259x224").for(:phone)
	should_not allow_value("800-EAT-FOOD").for(:phone)
	should_not allow_value("412/268/3259").for(:phone)
	should_not allow_value("412-2683-259").for(:phone)

	# Validating email addresses
	should allow_value("fred@fred.com").for(:email)
	should allow_value("fred@andrew.cmu.edu").for(:email)
	should allow_value("my_fred@fred.org").for(:email)
	should allow_value("fred123@fred.gov").for(:email)
	should allow_value("my.fred@fred.net").for(:email)

	should_not allow_value("fred").for(:email)
	should_not allow_value("fred@fred,com").for(:email)
	should_not allow_value("fred@fred.uk").for(:email)
	should_not allow_value("my fred@fred.com").for(:email)
	should_not allow_value("fred@fred.con").for(:email)

	# Testing other methods with a context
	context "Given context" do
		# create the objects I want with factories
		setup do
			create_curriculums
			create_camps
			create_instructors
			create_camp_instructors
		end

		#destroy the objs
		teardown do
			destroy_camp_instructors
			destroy_instructors
			destroy_camps
			destroy_curriculums
		end

		should 'proper_name joins the first and last name' do
			instance = Instructor.new(first_name: 'Justin', last_name: 'Hilliard')
			assert_equal 'Justin Hilliard', instance.proper_name
		end

		should 'proper_name should only be the last name when the first_name is nil' do
			instance = Instructor.new(first_name: nil, last_name: 'Hilliard')
			assert_equal 'Hilliard', instance.proper_name
		end

		should 'proper_name should only be the first name when the last_name is nil' do
			instance = Instructor.new(first_name: 'Justin', last_name: nil)
			assert_equal 'Justin', instance.proper_name
		end

		should "return all the curriculums in alphabetical order" do
			assert_equal ["Alpha Alphaton", "Beta Betaton", "Imma Nardwar", "Zeta Zetaton"], Instructor.alphabetical.map{|o| o.proper_name}
		end

		should "return all instructors that need a bio" do
			assert_equal 1, Instructor.needs_bio.size
			assert_equal ["Alpha Alphaton"], Instructor.needs_bio.alphabetical.map{|o| o.proper_name}
		end

		should "inactive scope that works" do
			assert_equal 1, Instructor.inactive.size
			assert_equal ["Zeta Zetaton"], Instructor.inactive.alphabetical.map{|o| o.proper_name}
		end 

		should "checks the name method" do
			assert_equal "Imma Nardwar", @imma.proper_name
		end

		should "checks proper_name method" do
			assert_equal "Zetaton, Zeta", @zeta.name
		end

		should "checks for_camp method" do
			assert_equal [@imma], Instructor.for_camp(@cw1)
		end 

		should "checks for_camp for multiple instructors" do 
			assert_equal [@alpha, @beta], Instructor.for_camp(@cw2)
		end

		should "active scope that works" do
			assert_equal 3, Instructor.active.size
			assert_equal ["Alpha Alphaton", "Beta Betaton", "Imma Nardwar"], Instructor.active.alphabetical.map{|o| o.proper_name}
		end

		should "shows that Alpha's phone is stripped of non-digits" do
    		assert_equal "4562952948", @alpha.phone
    		assert_equal "3453453454", @beta.phone
    	end
	end
end
