FactoryGirl.define do

	#create instructor obj
	factory :instructor do
		first_name "Imma"
		last_name "Nardwar"
		bio "I am a lazy dude with a weird accent who interviews celeberities"
		email { |a| "#{a.first_name}.#{a.last_name}@example.com".downcase }
		phone { rand(10 ** 10).to_s.rjust(10,'0') }
		active true
	end

	#create camp instructor obj
	factory :camp_instructor do
		association :instructor
		association :camp
	end

	#create camp obj
	factory :camp do
		association :curriculum
		cost 130
		start_date 10.weeks.from_now.to_date 
		end_date 12.weeks.from_now.to_date
		time_slot 'am'
		max_students 4
		active true
	end

	#create curriculum obj
	factory :curriculum do 
		name "The Awesome Defense"
		description "This camp teaches the student to win any game of chess ever"
		min_rating 200
		max_rating 400
		active true
	end


end