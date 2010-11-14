require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => 'Example User', :email => 'user@example.com'}
  end
  
  it "should create a new instance given a valid attr" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ''))
    no_name_user.should_not be_valid
  end
  
  it "should require a email" do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end
  
  it "rejeitar nomes muitos longos" do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it 'aceitar emails válidos' do
    addrs = %w[user@foo.com THE_USER@boo.bar.org first.last@foo.br]
    addrs.each do |addr|
      valid_email_usr = User.new(@attr.merge(:email => addr))
      valid_email_usr.should be_valid
    end
  end
  
  it 'rejeitar emails inválido' do
    addrs = %w[user@foo,com user_ar_foo.org exemplo.user@prov.]
    addrs.each do |addr|
      invalid_email_usr = User.new(@attr.merge(:email => addr))
      invalid_email_usr.should_not be_valid
    end
  end
  
  it 'deve rejeitar emails duplicados' do
    User.create!(@attr)
    user = User.new(@attr)
    user.should_not be_valid
  end
  
  it 'deve rejeitar emails identicos (upper case/lower case)' do
    upcase = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcase))
    user = User.new(@attr)
    user.should_not be_valid
  end
end
