FactoryBot.define do
  factory :phone do
    number { Faker::PhoneNumber.phone_number.gsub(/ x\d+/, "") }
    phone_type { "home" }
    primary { true }

    trait :valid do
      number { "+13127474300" } # Chicago Public Library
    end

    trait :invalid do
      number { "+15555555555" }
    end
  end
end
