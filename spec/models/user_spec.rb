require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
       :name                  => 'Example User', 
       :email                 => 'user@example.com',
       :password              => 'foobar',
       :password_confirmation => 'foobar'
    }
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
  
  describe "senhas" do
    
    before(:each) do
      @user = User.new(@attr)
    end
    
    it "deve possuir um atributo 'senha'" do
      @user.should respond_to(:password)
    end
    
    it "deve possuir um atributo 'confirmacao da senha'" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe 'validacao da senha' do
    it 'deve requisitar uma senha' do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).
        should_not be_valid
    end
    
     it 'deve requisitar uma confirmacao de senha' do
        User.new(@attr.merge(:password_confirmation => 'invalid')).
          should_not be_valid
      end
      
      it 'deve rejeitar senhas muito curtas' do
        short = 'a' * 5
        hash  = @attr.merge(:password => short, :password_confirmation => short)
        User.new(hash).should_not be_valid
      end
      
      it 'deve rejeitar senhas muito longas' do
        long = 'a' * 41
        hash  = @attr.merge(:password => long, :password_confirmation => long)
        User.new(hash).should_not be_valid
      end
  end
  
  describe 'senha criptografada' do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it 'deve haver um campo para a senha criptografada' do
      @user.should respond_to(:encrypted_password)
    end
    
    it 'deve definir uma senha criptografada' do
      @user.encrypted_password.should_not be_blank
    end
    
    it 'deve haver "sal"' do
      @user.should respond_to(:salt)
    end
  
    describe 'has_password? method' do
  
      it 'should exist' do
        @user.should respond_to(:has_password?)
      end
    
      it 'deve retornar true se a senha estiver correta' do
        @user.has_password?(@attr[:password]).should be_true
      end
    
      it 'deve retornar false se a senha não estiver correta' do
        @user.has_password?('invalida').should be_false
      end
    end 
    
    describe 'authenticate method' do
      
      it 'deve existir' do
        User.should respond_to(:authenticate)
      end
      
      it 'deve retornar nil quando email/senha esta incorreto' do
        User.authenticate(@attr[:email], 'wrongpass').should be_nil
      end
      
      it 'deve retornar nil com um email sem usuario' do
        User.authenticate('bar@foo.com',@attr[:password]).should be_nil
      end
      
      it 'deve retornar o usuario qdo a autenticação funcionar' do
        User.authenticate(@attr[:email],@attr[:password]).should == @user
      end
    end
  end
end
