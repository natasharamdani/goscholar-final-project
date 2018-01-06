require 'rails_helper'

describe Gopay do
  before :each do
    @user = create(:user)
    # @driver = create(:driver)
  end

  context "with user as gopayable" do
    it "is valid with a balance" do
      expect(build(:gopay, gopayable: @user)).to be_valid
    end

    it "is invalid without balance" do
      gopay = build(:invalid_gopay, gopayable: @user)
      gopay.valid?
      expect(gopay.errors[:balance]).to include("can't be blank")
    end

    it "is invalid with negative balance" do
      gopay = build(:gopay, balance: -20000, gopayable: @user)
      gopay.valid?
      expect(gopay.errors[:balance]).to include("must be greater than or equal to 0")
    end
  end
end
