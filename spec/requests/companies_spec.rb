require 'rails_helper'

RSpec.describe "Companies", type: :request do
  before(:each) do
    @company = FactoryGirl.create(:two_level_company_tree)
  end
  describe "has not access without auth" do

    it "has not access for show all" do
      get companies_path
      expect(response).to have_http_status(401)
    end
    it "has not access for show one" do
      get company_path(@company)
      expect(response).to have_http_status(401)
    end
    it "has not access for update" do
      put company_path(@company)
      expect(response).to have_http_status(401)
    end
  end
  describe "has access with auth" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @auth_header = Devise::JWT::TestHelpers.auth_headers({}, @user)
    end

    let(:valid_params) {{company:{name: 'new name'}}}
    context  'can get' do
      it "has access for show all" do
        get companies_path, headers: @auth_header, as: :json
        expect(response.body).to have_http_status(200)
      end
      it "has access for show one" do
        get company_path(@company),headers: @auth_header, as: :json
        expect(response).to have_http_status(200)
      end
    end

    it "cannot not update if not admin" do
      put company_path(@company),headers: @auth_header, as: :json,params:valid_params
      expect(response.body).to include_json({error: 'You have not rights for update'})
    end
    context  'can update if admin' do
      before(:each) do
        @user.update(role: :admin, company: @company)
      end
      it "admin can update own company" do

        put company_path(@company),headers: @auth_header, as: :json,params:valid_params
        expect(response.body).to include_json({success: true})
      end
      it "admin can update child company" do
        child =@company.children.first
        put company_path(child),headers: @auth_header, as: :json,params:valid_params
        expect(response.body).to include_json({success: true})
      end
      it "admin can update subchild company" do
        child = @company.children.first.children.first
        put company_path(child),headers: @auth_header, as: :json,params:valid_params
        expect(response.body).to include_json({success: true})
      end
    end

  end
end
