require 'test_helper'

class CurriculumTest < ActiveSupport::TestCase
	# Start by using ActiveRecord macros
	# Relationship macros...
	should have_many (:camps)

	# Validation macros
	should validate_presence_of (:name)
	should validate_presence_of (:min_rating)
	should validate_presence_of (:max_rating)

	# Validation min_rating & max_rating 
	should_not allow_value(-3).for(:min_rating)
	should_not allow_value(-3).for(:max_rating)
	should allow_value(2000).for(:min_rating)
	should allow_value(2000).for(:max_rating)
	should_not allow_value(4000).for(:min_rating)
	should_not allow_value(4000).for(:max_rating)
	should_not allow_value('seven').for(:min_rating)
	should_not allow_value('seven').for(:max_rating)

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

		should "return all the curriculums in alphabetical order" do
			assert_equal ["Alpha Attack", "Beta Attack", "The Awesome Defense", "Zeta Attack"], Curriculum.alphabetical.map{|o| o.name}
		end

		should "does not allow names to be the same for curriculums" do
			deny FactoryGirl.build(:curriculum, name: "Alpha Attack").valid?
		end

		should "do not allow inappropriate min and max ratings" do 
			deny FactoryGirl.build(:curriculum, min_rating: -4).valid?
			deny FactoryGirl.build(:curriculum, max_rating: -4).valid?
			deny FactoryGirl.build(:curriculum, min_rating: 4000).valid?
			deny FactoryGirl.build(:curriculum, max_rating: 4000).valid?
			deny FactoryGirl.build(:curriculum, min_rating: "seven").valid?
			deny FactoryGirl.build(:curriculum, max_rating: "seven").valid?
			deny FactoryGirl.build(:curriculum, min_rating: nil).valid?
			deny FactoryGirl.build(:curriculum, max_rating: nil).valid?
		end

		should "checks the rating_check_min and rating_check_max methods" do 
			deny FactoryGirl.build(:curriculum, min_rating: 75).valid?
			deny FactoryGirl.build(:curriculum, max_rating: 75).valid?
		end

		should "tests the for_rating scope" do 
			assert_equal 3, Curriculum.for_rating(250).size
			assert_equal  ["Alpha Attack", "Beta Attack", "The Awesome Defense"], Curriculum.alphabetical.for_rating(250).map{|o| o.name}
		end

		should "inactive scope that works" do
			assert_equal ["Zeta Attack"], Curriculum.inactive.alphabetical.map{|o| o.name}
		end 

		should "active scope that works" do
			assert_equal ["Alpha Attack",  "Beta Attack", "The Awesome Defense"], Curriculum.active.alphabetical.map{|o| o.name}
		end
	end
end
