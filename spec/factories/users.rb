FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    first_name { Gimei.name.first.hiragana }
    last_name { Gimei.name.last.hiragana }
  end

  # trait :general do
  #   role { :general }
  # end
  #
  # trait :admin do
  #   role { :admin }
  # end
end
