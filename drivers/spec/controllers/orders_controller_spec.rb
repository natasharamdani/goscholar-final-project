require 'rails_helper'

describe OrdersController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
    @service = create(:service)
    @order = create(:order, user: user, service: @service)
  end

  describe 'GET #index' do
    it "populates an array of all orders from logged in user" do
      get :index
      expect(assigns(:orders)).to match_array([@order])
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it "assigns the requested order to @order" do
      get :show, params: { id: @order }
      expect(assigns(:order)).to eq(@order)
    end

    it "renders the :show template" do
      get :show, params: { id: @order }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it "assigns a new Order to @order" do
      get :new
      expect(assigns(:order)).to be_a_new(Order)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new order in the database" do
        expect{
          post :create, params: { order: attributes_for(:order), service: @service }
        }.to change(Order, :count).by(1)
      end

      it "redirects to user order page" do
        post :create, params: { order: attributes_for(:order), service: @service }
        expect(response).to redirect_to orders_path
      end
    end

    context "with invalid attributes" do
      it "does not save the new order in the database" do
        expect{
          post :create, params: { order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { order: attributes_for(:invalid_order) }
        expect(response).to render_template :new
      end
    end
  end
end
