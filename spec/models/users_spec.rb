require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { should validate_presence_of :username }
  it { should validate_presence_of :password_digest }
  it { should validate_presence_of :session_token }    # ??
 
  it { should validate_length_of(:password).is_at_least(6) }

  # it { should have_many(:goals) }
  # it { should have_many(:cheers) }
  # it { should have_many(:comments) }


  describe "uniqueness" do
    
    #create(:user) has to be inside a before each or a let block so that it
    #does not throw a syntax error.
    #Contrary to using a let block, using before each does not create a local variable that we
    #can reference, but instead just places an instance of user from FactoryBot inside our 
    #test database so that we can validate the uniqueness of the columns :username and :session_token bellow. 
    #to use before each we must access the instance with User.last
    before(:each) do 
      create(:user)
    end

    it{ should validate_uniqueness_of :username }
    it{ should validate_uniqueness_of :session_token }
  end

  #FIGVAPER
  
  describe "is_password?" do
    let!(:user) { create(:user) } #creates a local variable user with an user instance inside of it. The instance comes from FactoryBot

    context "with a valid password" do
      it "should return true" do
        expect(user.is_password?("starwars")).to be(true)
      end
    end

    context "with an invalid password" do
      it "should return false" do
        expect(user.is_password?("startrek")).to be(false)
      end
    end
  end
  
  
  describe "::find_by_credentials" do
    before(:each) { create(:user) }
    

    it "returns user when password and username match" do
      user = User.find_by_credentials(User.last.username, "starwars")

      expect(user).to eq(User.last)
    end

    it "return nil if password and username do not match" do
      user = User.find_by_credentials(User.last.username, "startrek")
      expect(user).to eq(nil)
    end
  end

  describe "::generate_session_token" do
    it "returns a SecureRandom " do

      session_token1 = User.generate_session_token
      session_token2 = User.generate_session_token

      expect(session_token1).to_not eq(session_token2)
    end
  end
  
  describe "reset_session_token! and save to database" do
    let!(:user) { create(:user) }

    it "resets the session token and saves to database" do
    
      session_token1 = user.session_token
      user.reset_session_token!
      session_token2 = User.last.session_token

      expect(session_token1).to_not eq(session_token2)
    end
  end

  describe "after_initialize callback" do
    let!(:user) { User.new }

    it "expects to receive ensure_session_token method" do
      expect(user.session_token).to_not eq(nil)
    end
  end
end