require 'rails_helper'

describe Driver do
  it "is valid with fullname, phone, email, password, and password confirmation" do
    expect(build(:driver)).to be_valid
  end

  it "is invalid without fullname" do
    driver = build(:invalid_driver)
    driver.valid?
    expect(driver.errors[:fullname]).to include("can't be blank")
  end

  it "is invalid without phone number" do
    driver = build(:invalid_driver)
    driver.valid?
    expect(driver.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with duplicate phone number" do
    driver1 = create(:driver, phone: "1234567890")
    driver2 = build(:driver, phone: "1234567890")

    driver2.valid?
    expect(driver2.errors[:phone]).to include("has already been taken")
  end

  it "is invalid with non-numeric phone number" do
    driver = build(:driver, phone: "xyz")
    driver.valid?
    expect(driver.errors[:phone]).to include("is not a number")
  end

  it "is invalid without email address" do
    driver = build(:invalid_driver)
    driver.valid?
    expect(driver.errors[:email]).to include("can't be blank")
  end

  it "is invalid with duplicate email address" do
    driver1 = create(:driver, email: "name@mail.com")
    driver2 = build(:driver, email: "name@mail.com")

    driver2.valid?
    expect(driver2.errors[:email]).to include("has already been taken")
  end

  it "is invalid with email address other than given format" do
    driver = build(:driver, email: "mail")
    driver.valid?
    expect(driver.errors[:email]).to include("has invalid format")
  end

  context "on new driver" do
    it "is invalid without a password" do
      driver = build(:invalid_driver)
      driver.valid?
      expect(driver.errors[:password]).to include("can't be blank")
    end

    it "is invalid with less than 8 characters password" do
      driver = build(:driver, password: "short", password_confirmation: "short")
      driver.valid?
      expect(driver.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it "is invalid with a confirmation mismatch" do
      driver = build(:driver, password: "password", password_confirmation: "passwordd")
      driver.valid?
      expect(driver.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context "on an existing driver" do
    before :each do
      @driver = create(:driver)
    end

    it "is valid with no changes" do
      expect(@driver.valid?).to be true
    end

    it "is invalid with an empty password" do
      @driver.password_digest = ""
      @driver.valid?
      expect(@driver.errors[:password]).to include("can't be blank")
    end

    it "is valid with a new (valid) password" do
      @driver.password = "newpassword"
      @driver.password_confirmation = "newpassword"
      expect(@driver.valid?).to be true
    end
  end
end
