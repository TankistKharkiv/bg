namespace :bg do

  desc 'add some companies and users'
  task :seed => :environment do
    if Rails.env.production?
      warn "Can't seed your production database bro, too risky!"
    else

      # guaranteed_company = Company.create(name: 'guaranteed_company')
      # fadmin = User.create(first_name: 'fname',
      #             last_name: 'lname',
      #             email: 'admin@example.com',
      #             jti: "ed93042e-a586-45e3-9229-f311abcdc34b",
      #             company: guaranteed_company
      # )
      # #first lavel
      # 10.times do
      #   Company.create(name: Faker::Company.unique.bs)
      # end
      fl_ids = Company.top_level.ids
      (20..40).to_a.sample.times do
        Company.create(name: Faker::Company.unique.bs, parent_id: fl_ids.sample)
      end
      #   second level
      sl_ids = Company.where.not(parent_id: nil).ids
      (40..80).to_a.sample.times do
        Company.create(name: Faker::Company.unique.bs,  parent_id: fl_ids.sample)
      end
      all_ids = Company.ids
      150.times do
        User.create(
                email: Faker::Internet.unique.email,
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                jti: SecureRandom.uuid,
                company_id: all_ids.sample
        )
      end
    end
  end
end
