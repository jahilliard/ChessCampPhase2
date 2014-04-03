module Contexts

	def create_curriculums
		@stupiddefense = FactoryGirl.create(:curriculum)
		@alphaattack = FactoryGirl.create(:curriculum, name: "Alpha Attack")
		@betaattack =  FactoryGirl.create(:curriculum, name: "Beta Attack")
		@zetaattack = FactoryGirl.create(:curriculum, name: "Zeta Attack", min_rating: 1000, max_rating: 2000, active: false)
	end 

	def destroy_curriculums
		@stupiddefense.destroy
		@alphaattack.destroy
		@betaattack.destroy 
		@zetaattack.destroy
	end 

	def create_instructors
		@imma = FactoryGirl.create(:instructor)
		@alpha = FactoryGirl.create(:instructor, first_name: "Alpha", last_name: "Alphaton", phone: "(456) 295-2948", bio: nil)
		@zeta = FactoryGirl.create(:instructor, first_name: "Zeta", last_name: "Zetaton", active: false)
		@beta = FactoryGirl.create(:instructor, first_name: "Beta", last_name: "Betaton", phone: "345-345-3454")
	end 

	def destroy_instructors 
		@imma.destroy
		@alpha.destroy
		@zeta.destroy
		@beta.destroy
	end

	def create_camps
		@cw2 = FactoryGirl.create(:camp, curriculum: @alphaattack, start_date: 11.weeks.from_now.to_date, end_date: 13.weeks.from_now.to_date, time_slot: 'pm')
		@cw1 = FactoryGirl.create(:camp, curriculum: @stupiddefense)
		@cw3 = FactoryGirl.create(:camp, curriculum: @betaattack, start_date: 12.weeks.from_now.to_date, end_date: 14.weeks.from_now.to_date, time_slot: 'pm', active: false)
	end

	def destroy_camps
		@cw1.destroy
		@cw2.destroy
		@cw3.destroy
	end

	def create_camp_instructors
		@ci1 = FactoryGirl.create(:camp_instructor, camp: @cw1, instructor: @imma)
		@ci2 = FactoryGirl.create(:camp_instructor, camp: @cw2, instructor: @alpha)
		@ci3 = FactoryGirl.create(:camp_instructor, camp: @cw2, instructor: @beta)
	end 

	def destroy_camp_instructors
		@ci1.destroy
		@ci2.destroy
		@ci3.destroy
	end


end