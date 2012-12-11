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

describe PaypalPaymentsController do
  
  before do
    @check_in_order = FactoryGirl.create(:balance_check_in_order)
    puts @check_in_order.inspect
  end

  # This should return the minimal set of attributes required to create a valid
  # PaypalPayment. As you add validations to PaypalPayment, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:paypal_payment)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PaypalPaymentsController. Be sure to keep this updated too.
  def valid_session
    {}
  end


  describe "POST create" do
    describe "with valid params" do
      it "creates a new PaypalPayment" do
        expect {
          post :create, {:paypal_payment => valid_attributes, :invoice => @check_in_order.id, :charset => 'utf-8' }, valid_session
        }.to change(PaypalPayment, :count).by(1)
      end

      it "assigns a newly created paypal_payment as @paypal_payment" do
        post :create, {:paypal_payment => valid_attributes, :invoice => @check_in_order.id, :charset => 'utf-8'}, valid_session
        assigns(:paypal_payment).should be_a(PaypalPayment)
        assigns(:paypal_payment).should be_persisted
      end

      it "redirects to the created paypal_payment" do
        post :create, {:paypal_payment => valid_attributes, :invoice => @check_in_order.id, :charset => 'utf-8'}, valid_session
        response.should be_success
      end
    end

    #describe "with invalid params" do
    #  it "returns an error" do
    #    # Trigger the behavior that occurs when invalid params are submitted
    #    PaypalPayment.any_instance.stub(:save).and_return(false)
    #    expect {
    #      post :create, { :paypal_payment => nil, :charset => "utf-8" }, valid_session
    #    }.to raise_error 
    #    #response.should be_error
    #    #assigns(:paypal_payment).should be_a_new(PaypalPayment)
    #  end
    #  
    #end
  end

end
