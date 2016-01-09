FactoryGirl.define do
  factory :device do
    device_id { Faker::Lorem.word }
    reg_id { Faker::Lorem.word }
  end
end
