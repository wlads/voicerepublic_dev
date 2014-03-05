require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AccountsController do


  before  do
    @user = FactoryGirl.create(:user)
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_or_guest_user => @user
  end
  
  # This should return the minimal set of attributes required to create a valid
  # Account. As you add validations to Account, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:account).merge(:user_id => @user.id)
  end
  

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AccountsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET show" do
    it "assigns the requested account as @account" do
      account = @user.account
      get :show, {:id => account.to_param, :user_id => @user.id}, valid_session
      assigns(:account).should eq(account)
    end
  end

  #describe "GET new" do
  #  it "assigns a new account as @account" do
  #    get :new, {:user_id => @user}, valid_session
  #    assigns(:account).should be_a_new(Account)
  #  end
  #end

  describe "GET edit" do
    it "assigns the requested account as @account" do
      account = @user.account #Account.create! valid_attributes
      get :edit, {:user_id => @user}, valid_session
      assigns(:account).should eq(account)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested account" do
        account = Account.create! valid_attributes
        # Assuming there are no other accounts in the database, this
        # specifies that the Account created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Account.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, { :user_id => account.user, :account => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested account as @account" do
        account = @user.account
        put :update, {:user_id => account.user.id, :account => valid_attributes }, valid_session
        assigns(:account).should eq(account)
      end

      it "redirects to the profile of user" do
        account = Account.create! valid_attributes
        put :update, {:user_id => account.user, :account => valid_attributes}, valid_session
        response.should redirect_to(user_url(:id => account.user))
      end
    end

    describe "with invalid params" do
      it "assigns the account as @account" do
        account = Account.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Account.any_instance.stub(:save).and_return(false)
        put :update, {:user_id => @user, :account => {}}, valid_session
        assigns(:account).should eq(@user.account)
      end

      it "re-renders the 'edit' template" do
        account = Account.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Account.any_instance.stub(:save).and_return(false)
        put :update, {:user_id => @user, :account => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end
  
end
