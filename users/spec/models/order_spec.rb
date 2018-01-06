require 'rails_helper'

describe Order do
  before :each do
    @user = create(:user)
    @goride = create(:service, service_name: "Go-Ride", price_per_km: 1500)
    @gocar = create(:service, service_name: "Go-Car", price_per_km: 2500)
  end

  it "is valid with origin, destination, and payment type" do
    expect(build(:order, user: @user, service: @goride)).to be_valid
  end

  it "is invalid without origin" do
    order = build(:order, origin: "")
    order.valid?
    expect(order.errors[:origin]).to include("can't be blank")
  end

  it "is invalid without destination" do
    order = build(:order, destination: "")
    order.valid?
    expect(order.errors[:destination]).to include("can't be blank")
  end

  it "is invalid without payment type" do
    order = build(:invalid_order)
    order.valid?
    expect(order.errors[:payment_type]).to include("can't be blank")
  end

  it "is invalid with wrong payment type" do
    expect{ build(:order, payment_type: "Grab Pay") }.to raise_error(ArgumentError)
  end

  describe "Google maps API" do
    before :each do
      @order = build(:order)
      @order.origin = "Kemang"
      @order.destination = "Blok M"
    end

    context "with valid locations" do
      it "returns distance in km" do
        expect(@order.get_distance).to eq(3.2)
      end

      context "calculate price" do
        context "for Go-Ride service" do
          before :each do
            @order.service = @goride
          end

          it "returns price" do
            expect(@order.calculate_price).to eq(4800)
          end

          it "returns 1500 if distance < 1km" do
            @order.destination = "Kemang"
            expect(@order.calculate_price).to eq(1500)
          end
        end

        context "for Go-Car service" do
          before :each do
            @order.service = @gocar
          end

          it "returns price" do
            expect(@order.calculate_price).to eq(8000)
          end

          it "returns 2500 if distance < 1km" do
            @order.destination = "Kemang"
            expect(@order.calculate_price).to eq(2500)
          end
        end
      end
    end

    context "with invalid location(s)" do
      it "returns error for unknown origin" do
        order = build(:order, origin: "xyz")
        order.valid?
        expect(order.errors[:origin]).to include("is invalid")
      end

      it "returns error for unknown destination" do
        order = build(:order, destination: "xyz")
        order.valid?
        expect(order.errors[:destination]).to include("is invalid")
      end
    end
  end
end
