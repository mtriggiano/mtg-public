module ControllerMacros
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods

    def it_should_require_admin_for_actions(*actions)
      actions.each do |action|
        it "#{action} action should require admin" do
          loggin_as_common_user
          get action, params: {id: 1}
          response.should redirect_to(root_path)
        end
      end
    end

    def it_should_require_logged_user_for_actions(*actions)
      actions.each do |action|
        it "#{action} action should require admin" do
          loggin_as_common_user
          get action, params: {id: 1}
          response.should redirect_to(new_user_sign_in_path)
        end
      end
    end

  end

  def login_as_company_owner company
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryBot.build(:user, company_owner: true, company_id: company.id)
    login_as( @user, :scope => :user)
  end

  def sign_in_as_company_owner company
    require 'rails_helper'
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = create(:user, company_owner: true, company_id: company.id)
    sign_in @user
  end

  def login_as_admin
    sign_in FactoryBot.build(:user, :admin) # Using factory bot as an example
  end

  def loggin_as_common_user
    user = FactoryBot.build(:user)
    sign_in user
  end

  def create_client user
    @client = build(:client)
    @client.extend(Virtus.model)
    @client.attribute :user, User
    @client.user = user
    @client.save
  end
end
