FactoryGirl.define do
  factory :company do
    name 'some company'
  end

  factory :company_tree, class: Company do
    name 'main company'
    after(:create) do |parent|
      parent.children = create_list(:company, 2)
    end
  end
  factory :two_level_company_tree, class: Company do
    name 'general company'
    after(:create) do |parent|
      parent.children = create_list(:company_tree, 2)
    end
  end


  factory :user do
    email 'john@doe.com'
    first_name 'John'
    last_name 'Doe'
    password 'password'
    password_confirmation 'password'
    role 0
    company
    jti "37ddbe5a-0365-419f-b8b9-d8471d1633c1"
  end
end