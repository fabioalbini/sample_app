require 'spec_helper'

describe UsersController do
  render_views
  
  describe "Get 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it 'deve funcionar' do
      get :show, :id => @user.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign up")
    end
  end

end
