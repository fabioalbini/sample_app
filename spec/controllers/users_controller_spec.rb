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
    
    it 'deve encontrar o usuario correto' do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
    
    it 'deve possuir o titulo correto' do
      get :show, :id => @user.id
      response.should have_selector('title', :content => @user.name)
    end
    
    it 'deve possuir o nome do usuario' do
      get :show, :id => @user.id
      response.should have_selector('h1', :content => @user.name)
    end
    
    it 'deve possuir uma imagem para o perfil' do
      get :show, :id => @user.id
      response.should have_selector('h1>img', :class => 'gravatar')
    end
    
    it 'deve possuir a url correta' do
      get :show, :id => @user.id
      response.should have_selector('td>a', :content => user_path(@user.id),
                                          :href => user_path(@user.id))
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
