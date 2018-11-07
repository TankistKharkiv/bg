require 'rails_helper'

RSpec.describe "Companies", type: :request do


  let(:valid_update_params) {{company:{name: 'new name'}}}
  before(:each) do
   @companies =  FactoryGirl.create_list(:two_level_company_tree, 5)
   @company = @companies.first
   @child = @company.children.first
   @subchild = @child.children.first
  end
  let(:user){FactoryGirl.create(:user, company: @company)}
  let(:user_auth_headers){Devise::JWT::TestHelpers.auth_headers({}, user)}
  let(:admin){FactoryGirl.create(:user, company: @company, role: :admin)}
  let(:admin_auth_headers){Devise::JWT::TestHelpers.auth_headers({}, admin)}

  describe "has not access without auth" do

    it "view list has 401 status" do
      get companies_path
      expect(response).to have_http_status(401)
    end
    it "view single has 401 status" do
      get company_path(@company)
      expect(response).to have_http_status(401)
    end
    it "update has 401 status" do
      put company_path(@company)
      expect(response).to have_http_status(401)
    end
  end
  describe "user can get with auth" do

    context  'should get company list' do
      it "response has 200 status" do
        get companies_path, headers: user_auth_headers, as: :json
        expect(response).to have_http_status(200)
      end
      it "response must contain all companies" do

        get companies_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(@companies.count)
      end
      it "response must includes company name " do
        get companies_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['name']).to eq(@companies.first.name)
      end
      it "response must contain children" do
        get companies_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['children']).not_to be_nil
      end
      it "response must contain children name" do
        get companies_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['children'].first['name']).to eq(@child.name)
      end
      it "response must includes all children" do
        get companies_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['children'].length).to eq(2)
      end
      it "response must contain children name" do
        get companies_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['children'].first['children'].first['name']).to eq(@subchild.name)
      end
      it "response must contain subchildren" do
        get companies_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['children'].first['children']).not_to be_nil
      end
      it "response must contain all subchildren" do
        get companies_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['children'].first['children'].length).to eq(2)
      end
    end

    context 'should get single company' do
      it "response must has 200 status code" do
        get company_path(@company),headers: user_auth_headers, as: :json
        expect(response).to have_http_status(200)
      end
      it "response must include name" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to  eq(@company.name)
      end
      it "response must include children" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['children'].length).to eq(2)
      end
      it "response must include subchildren" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['children'].first['children'].length).to eq(2)
      end

      it "response must contain users" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['users'].length).to eq(@company.users.count)
      end
      it "response must contain user emails" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['users'].first['email']).to eq(@company.users.first.email)
      end
      it "response must contain user first names" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['users'].first['first_name']).to eq(@company.users.first.first_name)
      end
      it "response must contain user last names" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['users'].first['last_name']).to eq(@company.users.first.last_name)
      end
      it "response must contain user id" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['users'].first['id']).to eq(@company.users.first.id)
      end

      it "response must contain users" do
        get company_path(@company),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(@company.users.count)
      end
    end

  end

  describe "admin can update" do

    context  "his company" do

      it "response includes success status" do
        put company_path(@company),headers: admin_auth_headers, as: :json,params:valid_update_params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['success']).to eq(true)
      end

      it "response includes new name" do

        put company_path(@company),headers: admin_auth_headers, as: :json,params:valid_update_params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['company']['name']).to eq(valid_update_params[:company][:name])
      end
    end
    context  "child" do
      it "response includes success status" do
        put company_path(@child),headers: admin_auth_headers, as: :json,params:valid_update_params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['success']).to eq(true)
      end

      it "response includes new name" do
        put company_path(@child),headers: admin_auth_headers, as: :json,params:valid_update_params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['company']['name']).to eq(valid_update_params[:company][:name])
      end
    end
    context  "subchild" do
      it "response includes success status" do
        put company_path(@subchild),headers: admin_auth_headers, as: :json,params:valid_update_params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['success']).to eq(true)
      end

      it "response includes new name" do
        put company_path(@subchild),headers: admin_auth_headers, as: :json,params:valid_update_params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['company']['name']).to eq(valid_update_params[:company][:name])
      end
    end
  end
  describe "can't be updated" do
    it "if user is't admin" do
      put company_path(@company),headers: user_auth_headers, as: :json,params:valid_update_params
      expect(response.body).to include_json({error: 'You have not rights for update'})
    end
    context "if user is admin" do
      it "of other company" do
        put company_path(@companies.last),headers: admin_auth_headers, as: :json,params:valid_update_params
        expect(response.body).to include_json({error: 'You have not rights for update'})
      end
      it "not parent(for child)" do
        put company_path(@companies.last.children.last),headers: admin_auth_headers, as: :json,params:valid_update_params
        expect(response.body).to include_json({error: 'You have not rights for update'})
      end
      it "not parent(for subchild)" do
        put company_path(@companies.last.children.last),headers: admin_auth_headers, as: :json,params:valid_update_params
        expect(response.body).to include_json({error: 'You have not rights for update'})
      end
    end

    it "with company name more than 60 chars" do
      update_params = {company:{name: 'a'*61}}
      put company_path(@company),headers: admin_auth_headers, as: :json,params:update_params
      expect(response.body).to include_json({success:false,errors:{company:{name:["size cannot be greater than 60"]}}})
    end
    it "with company name less than 2 chars" do
      update_params = {company:{name: 'a'*2}}
      put company_path(@company),headers: admin_auth_headers, as: :json,params:update_params
      expect(response.body).to include_json({success:false,errors:{company:{name:["size cannot be less than 3"]}}})
    end
  end


end
