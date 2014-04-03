require 'test_helper'

class CampInstructorTest < ActiveSupport::TestCase
	# Start by using ActiveRecord macros
	# Relationship macros...
	should belong_to(:camp)
	should belong_to(:instructor)


	# Validation macros...
	should validate_presence_of (:camp_id)
	should validate_presence_of (:instructor_id)
	should_not allow_value("seven").for(:camp_id)
	should_not allow_value("seven").for(:instructor_id)


	# Context methods 
	context "Given Context" do
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
		should "only allow active camp ids" do
			deny FactoryGirl.build(:camp_instructor, camp: @cw3, instructor: @imma).valid?
		end

		should "only allow camp ids that exist" do
			camp_ids = Camp.active.map { |e| e.id }
			begin
				randnum = Random.rand(30)
			end while camp_ids.include?(randnum)
			deny FactoryGirl.build(:camp_instructor, camp_id: randnum, instructor: @imma).valid?
		end

		should "only allow active instructor ids" do
			deny FactoryGirl.build(:camp_instructor, camp: @cw2, instructor: @zeta).valid?
		end

		should "only allow instructor ids that exist" do
			instructor_ids = Instructor.active.map { |e| e.id }
			begin
				randnum = Random.rand(30)
			end while instructor_ids.include?(randnum)
			deny FactoryGirl.build(:camp_instructor, instructor_id: randnum, camp: @cw1).valid?
		end

		should "doesnt allow duplicate camp to be created" do 
			deny FactoryGirl.build(:camp_instructor, camp: @cw1, instructor: @imma).valid?
		end
		


	end
end
