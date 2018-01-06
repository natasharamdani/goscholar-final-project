require 'rails_helper'

describe UsersController do
  before :each do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe 'GET #index' do
    it "populates an array of all users" do
      get :index
      expect(assigns(:users)).to match_array([@user])
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it "assigns the requested user to @user" do
      get :show, params: { id: @user }
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the :show template" do
      get :show, params: { id: @user }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested user to @user" do
      get :edit, params: { id: @user }
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the :edit template" do
      get :edit, params: { id: @user }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new user in the database" do
        expect{
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it "redirects to users#index" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to users_path
      end
    end

    context "with invalid attributes" do
      it "does not save the new user in the database" do
        expect{
          post :create, params: { user: attributes_for(:invalid_user) }
        }.not_to change(User, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { user: attributes_for(:invalid_user) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context "with valid attributes" do
      it "locates the requested @user" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(assigns(:user)).to eq(@user)
      end

      it "saves new details (password)" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: "newpassword", password_confirmation: "newpassword") }
        @user.reload
        expect(@user.authenticate("newpassword")).to eq(@user)
      end

      it "redirects to users#index" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to user_path
      end

      it "disables login with old password" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: "newpassword", password_confirmation: "newpassword") }
        @user.reload
        expect(@user.authenticate("password")).to eq(false)
      end
    end

    context "with invalid attributes" do
      it "does not update the user in the database" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: nil, password_confirmation: nil) }
        @user.reload
        expect(@user.authenticate(nil)).to eq(false)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @user, user: attributes_for(:invalid_user) }
        expect(response).to render_template :edit
      end
    end
  end

  describe "top up gopay" do
    before :each do
      @user = create(:user)
      @gopay = create(:gopay, gopayable_type: "User", gopayable_id: @user.id)
      @user.gopay.balance = 20000
    end

    context "with valid amount" do
      it "will add the balance of gopay with amount" do
        patch :do_topup, params: { id: @user, amount: 1 }
        @user.reload
        expect(@user.gopay.balance).to eq(20001)
      end

      it "redirects to top up page" do
        patch :do_topup, params: { id: @user }
        expect(response).to redirect_to topup_user_path
      end
    end

    context "with invalid amount" do
      it "will not add the balance of gopay" do
        patch :do_topup, params: { id: @user, amount: "1a" }
        @user.reload
        expect(@user.gopay.balance).to eq(20000)
      end

      it "redirects to top up page" do
        patch :do_topup, params: { id: @user }
        expect(response).to redirect_to topup_user_path
      end
    end
  end
end
