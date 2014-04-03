require 'test_helper'

class CampTest < ActiveSupport::TestCase
	# Start by using ActiveRecord macros
	# Relationship macros...
	should have_many(:instructors).through(:camp_instructors)
	should belong_to(:curriculum)
	should have_many(:camp_instructors)

	# Validation Macros 
	should validate_presence_of(:start_date)
	should validate_presence_of(:end_date)
	should validate_presence_of(:time_slot)

	#Validation of time_slot
	should allow_value("am").for(:time_slot)
	should allow_value("pm").for(:time_slot)
	should allow_value("Am").for(:time_slot)
	should allow_value("Pm").for(:time_slot)
	should allow_value("aM").for(:time_slot)
	should allow_value("PM").for(:time_slot)

	should_not allow_value("banna").for(:time_slot)
	should_not allow_value("232").for(:time_slot)

	# # Validations for start_dates and end_dates
	should allow_value(2.weeks.from_now).for(:start_date)
	should allow_value(2.weeks.from_now).for(:end_date)
	should_not allow_value(2.weeks.ago).for(:start_date)
	should_not allow_value(2.weeks.ago).for(:end_date)
	should_not allow_value(nil).for(:start_date)
	should_not allow_value(nil).for(:end_date)

	# # Validates Cost
	should allow_value(120).for(:cost) 
	should_not allow_value(-120).for(:cost) 
	should_not allow_value("balls").for(:cost)
	should_not allow_value(nil).for(:cost)


	# Misc. Testing Methods 
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

		should "checks if the name method works" do
			assert_equal "The Awesome Defense", @cw1.name
			assert_equal "Alpha Attack", @cw2.name
			assert_equal "Beta Attack", @cw3.name
		end

		should "vaildate the cost" do
			deny FactoryGirl.build(:camp, curriculum: @alphaattack, cost: -120, time_slot: 'pm').valid?
		end

		should "return all the camp curriculum names in alphabetical order" do
			assert_equal ["Alpha Attack", "Beta Attack", "The Awesome Defense"], Camp.alphabetical.map{|o| o.name}
		end

		should "doesnt allow camp with same start_date and time_slot" do 
			deny FactoryGirl.build(:camp, curriculum: @alphaattack, start_date: 11.weeks.from_now.to_date, end_date: 13.weeks.from_now.to_date, time_slot: 'pm').valid?
		end

		should "doesnt allow camp with inactive curriculum id" do
			deny FactoryGirl.build(:camp, curriculum: @zetaattack).valid?
		end

		should "doesnt allow curriculum id that doesnt exist" do 
			deny FactoryGirl.build(:camp, curriculum_id: nil).valid?
		end

		should "tests the active scope" do 
			assert_equal 2, Camp.active.size
			assert_equal ["Alpha Attack", "The Awesome Defense"], Camp.alphabetical.active.map{|o| o.name}
		end 

		should "tests inactive scope" do
			assert_equal 1, Camp.inactive.size
			assert_equal ["Beta Attack"], Camp.alphabetical.inactive.map { |e| e.name }
		end

		should "tests the chronological scope" do 
			assert_equal ["The Awesome Defense", "Alpha Attack", "Beta Attack"], Camp.chronological.map { |e| e.name }
		end 

		should "tests the morning scope" do 
			assert_equal 1, Camp.morning.size
			assert_equal ["The Awesome Defense"], Camp.morning.map { |e| e.name }
		end

		should "tests the afternoon scope" do 
			assert_equal 2, Camp.afternoon.size
			assert_equal ["Alpha Attack", "Beta Attack"], Camp.afternoon.alphabetical.map { |e| e.name }
		end

		should "tests upcoming scope" do 
			assert_equal 3, Camp.upcoming.size
			assert_equal ["Alpha Attack", "Beta Attack", "The Awesome Defense"], Camp.upcoming.alphabetical.map { |e| e.name }
		end

		should "not allow end_date to be set before start_date" do
			deny FactoryGirl.build(:camp, curriculum: @betaattack, end_date: 3.weeks.from_now, start_date: 4.weeks.from_now).valid?
		end

		should "tests the past scope" do 
			@cw1.update(start_date: 4.weeks.ago, end_date: 3.weeks.ago)
			assert_equal 1, Camp.past.size
			assert_equal ["The Awesome Defense"], Camp.past.map { |e| e.name }
		end 

		should "tests the for_curriculum scope" do
			assert_equal 1, Camp.for_curriculum(@stupiddefense.id).size
			assert_equal 1, Camp.for_curriculum(@alphaattack.id).size
			assert_equal 1, Camp.for_curriculum(@betaattack.id).size
		end
	end
end
