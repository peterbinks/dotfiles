FactoryBot.define do
  factory :person do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    dob { rand(20..100).years.ago + rand(365).days }
    address
    after(:build) do |person|
      if person.phones.empty?
        person.phones << build(:phone)
      end
    end
    user
  end
end
