require 'rails_helper'

RSpec.describe Company, type: :model do
  before(:each) do
    @company = FactoryGirl.create(:company)
  end
  it 'is valid with valid attributes' do
    expect(@company).to be_valid
  end
  it 'able to has child company' do
    children = [FactoryGirl.create(:company, name: 'subcat1'),
                FactoryGirl.create(:company, name: 'subcat2'),
    ]
    expect {
      @company.children = children
    }.to_not raise_error

  end
end
