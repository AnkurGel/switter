FactoryGirl.define do
  factory :user do
    name                  "Ankur Goel"
    email                 "ankurgel@gmail.com"
    password              "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
  end
end
