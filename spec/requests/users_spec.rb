require 'rails_helper'

RSpec.describe "Users", type: :request do
  before(:each) do
    @company = FactoryGirl.create(:two_level_company_tree)
    @child = @company.children.first
    @subchild = @child.children.first
    @other_company = FactoryGirl.create(:two_level_company_tree)
    @user = FactoryGirl.create(:user, company: @company, email: 'j.d@dn.net')
  end
  let(:user_auth_headers){Devise::JWT::TestHelpers.auth_headers({}, @user)}
  let(:admin){FactoryGirl.create(:user, role: :admin, company: @company)}
  let(:admin_auth_headers){Devise::JWT::TestHelpers.auth_headers({}, admin)}

  describe "has not access without auth" do
    it "view list has 401 status" do
      get users_path
      expect(response).to have_http_status(401)
    end
    it "view single has 401 status" do
      get user_path(@user)
      expect(response).to have_http_status(401)
    end
    it "update has 401 status" do
      put user_path(@user)
      expect(response).to have_http_status(401)
    end
  end
  describe "can get users" do
    context 'can get users list' do
      let(:first_user){User.first}
      it "response has 200 status" do
        get users_path, headers: user_auth_headers, as: :json
        expect(response).to have_http_status(200)
      end
      it "response must contain all users" do
        get users_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.length).to eq(User.count)
      end
      it "response must includes first name " do
        get users_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['first_name']).to eq(first_user.first_name)
      end
      it "response must includes last name " do
        get users_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['last_name']).to eq(first_user.last_name)
      end
      it "response must includes first name " do
        get users_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['first_name']).to eq(first_user.first_name)
      end
      it "response must includes id " do
        get users_path, headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first['id']).to eq(first_user.id)
      end

    end
    context 'can get single user' do
      it "response has 200 status" do
        get user_path(@user),headers: user_auth_headers, as: :json
        expect(response).to have_http_status(200)
      end
      it "response has first name" do
        get user_path(@user),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['first_name']).to eq(@user.first_name)
      end
      it "response has last name" do
        get user_path(@user),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['last_name']).to eq(@user.last_name)
      end
      it "response has email" do
        get user_path(@user),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['email']).to eq(@user.email)
      end
      it "response has company" do
        get user_path(@user),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['company']).not_to be_nil
      end
      it "response has company name" do
        get user_path(@user),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['company']['name']).to eq(@user.company.name)
      end
      it "response has company id" do
        get user_path(@user),headers: user_auth_headers, as: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['company']['id']).to eq(@user.company_id)
      end
    end

  end

  describe 'can update' do
    let(:valid_update_params){{user: {first_name: 'Joe', last_name: 'Doe'}}}
    it 'if it is him self' do
      put user_path(@user),headers: user_auth_headers, as: :json,params:valid_update_params
      expect(response.body).to include_json(success: true, user: valid_update_params[:user])
    end
    it 'if it is admin' do
      put user_path(@user),headers: admin_auth_headers, as: :json,params:valid_update_params
      expect(response.body).to include_json(success: true, user: valid_update_params[:user])
    end
    it 'if it is admin of parent(for child)' do
      put user_path(@child.users.first),headers: admin_auth_headers, as: :json,params:valid_update_params
      expect(response.body).to include_json(success: true, user: valid_update_params[:user])
    end
    it 'if it is admin of parent(for subchild)' do
      put user_path(@subchild.users.first),headers: admin_auth_headers, as: :json,params:valid_update_params
      expect(response.body).to include_json(success: true, user: valid_update_params[:user])
    end
  end

  describe "cannot update" do
    let(:valid_update_params){{user: {first_name: 'Joe', last_name: 'Doe'}}}
    it 'email' do
      mail = 'new@mail.com'
      update_params = {user: {email: mail}}
      put user_path(@subchild.users.first),headers: admin_auth_headers, as: :json,params:update_params
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['email']).not_to eq(mail)
    end
    it 'other user (for no admin)' do
      put user_path(@other_company.users.first),headers: user_auth_headers, as: :json,params:valid_update_params
      expect(response.body).to  include_json({error: 'You have not rights for update'})
    end

    it 'user in other company' do
      put user_path(@other_company.users.first),headers: admin_auth_headers, as: :json,params:valid_update_params
      expect(response.body).to  include_json({error: 'You have not rights for update'})
    end

    context 'with failed validation' do
      it "first name less than 2 chars" do
        update_params = {user:{first_name: 'a'*2}}
        put user_path(@user),headers: user_auth_headers, as: :json,params:update_params
        expect(response.body).to include_json({success:false,errors:{user:{first_name:["size cannot be less than 3"]}}})
      end
      it "first name more than 60 chars" do
        update_params = {user:{first_name: 'a'*61}}
        put user_path(@user),headers: user_auth_headers, as: :json,params:update_params
        expect(response.body).to include_json({success:false,errors:{user:{first_name:["size cannot be greater than 60"]}}})
      end
      it "last name less than 2 chars" do
        update_params = {user:{last_name: 'a'*2}}
        put user_path(@user),headers: user_auth_headers, as: :json,params:update_params
        expect(response.body).to include_json({success:false,errors:{user:{last_name:["size cannot be less than 3"]}}})
      end
      it "last name more than 60 chars" do
        update_params = {user:{last_name: 'a'*61}}
        put user_path(@user),headers: user_auth_headers, as: :json,params:update_params
        expect(response.body).to include_json({success:false,errors:{user:{last_name:["size cannot be greater than 60"]}}})
      end
    end

  end
end
