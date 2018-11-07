require 'rails_helper'

RSpec.describe "Sessions", type: :request do

    describe 'user can login with valid data' do
      let(:user){FactoryGirl.create(:user, email: 'john@doe.com')}
      before(:each) do
        post '/api/users/sign_in', params:{
            user:
                {email: user.email, password: 'password'}
        }, as: :json
      end
      it "response has 200 code" do
        expect(response).to have_http_status(200)
      end
    end

    describe "user can't login without valid data" do
      before(:each) do
        @user = FactoryGirl.create(:user)

        post '/api/users/sign_in', params:{
            user:
                {email: 'john@doe.com', password: 'assword'}
        }, as: :json
      end
      it "response has 200 code" do
        expect(response).to have_http_status(401)
      end
    end

end
