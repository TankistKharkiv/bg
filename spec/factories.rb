FactoryGirl.define do
  factory :company do
    name {Faker::Company.unique.bs}
    after(:create) do |company|
      company.users = create_list(:user,3,  company: company)
    end
  end

  factory :company_tree, class: Company do
    name {Faker::Company.unique.bs}
    after(:create) do |parent|
      parent.children = create_list(:company, 2,  parent: parent)
      parent.users = create_list(:user,3,  company: parent)
    end
  end
  factory :two_level_company_tree, class: Company do
    name {Faker::Company.unique.bs}
    after(:create) do |parent|
      parent.children = create_list(:company_tree, 2, parent: parent)
      parent.users = create_list(:user,3,  company: parent)
    end

  end


  factory :user do
    email {Faker::Internet.unique.email}
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    password 'password'
    password_confirmation 'password'
    role 0
    company
    jti "37ddbe5a-0365-419f-b8b9-d8471d1633c1"
  end
end