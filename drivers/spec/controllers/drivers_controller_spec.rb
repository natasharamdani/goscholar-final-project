require 'rails_helper'

describe DriversController do
  before :each do
    @driver = create(:driver)
    session[:driver_id] = @driver.id
  end

  describe 'GET #index' do
    it "populates an array of all drivers" do
      get :index
      expect(assigns(:drivers)).to match_array([@driver])
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it "assigns the requested driver to @driver" do
      get :show, params: { id: @driver }
      expect(assigns(:driver)).to eq(@driver)
    end

    it "renders the :show template" do
      get :show, params: { id: @driver }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it "assigns a new Driver to @driver" do
      get :new
      expect(assigns(:driver)).to be_a_new(Driver)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested driver to @driver" do
      get :edit, params: { id: @driver }
      expect(assigns(:driver)).to eq(@driver)
    end

    it "renders the :edit template" do
      get :edit, params: { id: @driver }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:driver) }
        }.to change(Driver, :count).by(1)
      end

      it "redirects to drivers#index" do
        post :create, params: { driver: attributes_for(:driver) }
        expect(response).to redirect_to drivers_path
      end
    end

    context "with invalid attributes" do
      it "does not save the new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:invalid_driver) }
        }.not_to change(Driver, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { driver: attributes_for(:invalid_driver) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context "with valid attributes" do
      it "locates the requested @driver" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver) }
        expect(assigns(:driver)).to eq(@driver)
      end

      it "saves new details (password)" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: "newpassword", password_confirmation: "newpassword") }
        @driver.reload
        expect(@driver.authenticate("newpassword")).to eq(@driver)
      end

      it "redirects to drivers#index" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver) }
        expect(response).to redirect_to driver_path
      end

      it "disables login with old password" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: "newpassword", password_confirmation: "newpassword") }
        @driver.reload
        expect(@driver.authenticate("password")).to eq(false)
      end
    end

    context "with invalid attributes" do
      it "does not update the driver in the database" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: nil, password_confirmation: nil) }
        @driver.reload
        expect(@driver.authenticate(nil)).to eq(false)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @driver, driver: attributes_for(:invalid_driver) }
        expect(response).to render_template :edit
      end
    end
  end

  describe "top up gopay" do
    before :each do
      @driver = create(:driver)
      @gopay = create(:gopay, gopayable_type: "Driver", gopayable_id: @driver.id)
      @driver.gopay.balance = 20000
    end

    context "with valid amount" do
      it "will add the balance of gopay with amount" do
        patch :do_topup, params: { id: @driver, amount: 1 }
        @driver.reload
        expect(@driver.gopay.balance).to eq(20001)
      end

      it "redirects to top up page" do
        patch :do_topup, params: { id: @driver }
        expect(response).to redirect_to topup_driver_path
      end
    end

    context "with invalid amount" do
      it "will not add the balance of gopay" do
        patch :do_topup, params: { id: @driver, amount: "1a" }
        @driver.reload
        expect(@driver.gopay.balance).to eq(20000)
      end

      it "redirects to top up page" do
        patch :do_topup, params: { id: @driver }
        expect(response).to redirect_to topup_driver_path
      end
    end
  end
end
