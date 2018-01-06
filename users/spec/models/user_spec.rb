require 'rails_helper'

describe User do
  it "is valid with fullname, phone, email, password, and password confirmation" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without fullname" do
    user = build(:invalid_user)
    user.valid?
    expect(user.errors[:fullname]).to include("can't be blank")
  end

  it "is invalid without phone number" do
    user = build(:invalid_user)
    user.valid?
    expect(user.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with duplicate phone number" do
    user1 = create(:user, phone: "1234567890")
    user2 = build(:user, phone: "1234567890")

    user2.valid?
    expect(user2.errors[:phone]).to include("has already been taken")
  end

  it "is invalid with non-numeric phone number" do
    user = build(:user, phone: "xyz")
    user.valid?
    expect(user.errors[:phone]).to include("is not a number")
  end

  it "is invalid without email address" do
    user = build(:invalid_user)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with duplicate email address" do
    user1 = create(:user, email: "name@mail.com")
    user2 = build(:user, email: "name@mail.com")

    user2.valid?
    expect(user2.errors[:email]).to include("has already been taken")
  end

  it "is invalid with email address other than given format" do
    user = build(:user, email: "mail")
    user.valid?
    expect(user.errors[:email]).to include("has invalid format")
  end

  context "on new user" do
    it "is invalid without a password" do
      user = build(:invalid_user)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "is invalid with less than 8 characters password" do
      user = build(:user, password: "short", password_confirmation: "short")
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it "is invalid with a confirmation mismatch" do
      user = build(:user, password: "password", password_confirmation: "passwordd")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context "on an existing user" do
    before :each do
      @user = create(:user)
    end

    it "is valid with no changes" do
      expect(@user.valid?).to be true
    end

    it "is invalid with an empty password" do
      @user.password_digest = ""
      @user.valid?
      expect(@user.errors[:password]).to include("can't be blank")
    end

    it "is valid with a new (valid) password" do
      @user.password = "newpassword"
      @user.password_confirmation = "newpassword"
      expect(@user.valid?).to be true
    end
  end
end
