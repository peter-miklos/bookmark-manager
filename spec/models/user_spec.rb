require_relative '../../app/models/user.rb'

describe User do

  let!(:user) do User.create(email: "testuser1@john.com",
                             password: "my_secret_password",
                             password_confirmation: "my_secret_password")
  end

  context '#authenticate' do
    it 'authenticates the user and returns the user object if authentication complete' do
      expect(User.authenticate("testuser1@john.com", "my_secret_password")).to eq user
    end

    it 'authentication fails because of wrong password' do
      expect(User.authenticate("testuser1@john.com", "other_password")).to eq false
    end

    it 'authentication fails because of wrong email' do
      expect(User.authenticate("testuser1@rosie.com", "my_secret_password")).to eq false
    end
  end

  context '#generate_token' do

    it 'generates token and stores it in db' do
      user.generate_token
      expect(user.password_token).not_to be_nil
    end

    it "saves the time of generating token and saves it in db" do
      Time.freeze do
        user.generate_token
        expect(user.password_token_time).to eq Time.now
      end
    end
  end

  describe "#find_by_valid_token" do
    it "finds the user by valid token" do
      user.generate_token
      expect(User.find_by_valid_token(user.password_token)).to eq user
    end

    it "can't find user with an invalid token" do
      user.generate_token
      Timecop.travel(60*60*2) do
        expect(User.find_by_valid_token(user.password_token)).to eq nil
      end
    end
  end
end
