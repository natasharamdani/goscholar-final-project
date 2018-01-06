require 'rails_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe "POST create" do
    before :each do
      @user = create(:user, phone: '1234567890', password: 'password', password_confirmation: 'password')
    end

    context "with valid phone and password" do
      it "assigns user_id to session variables" do
        post :create, params: { phone: '1234567890', password: 'password' }
        expect(session[:user_id]).to eq(@user.id)
      end

      it "redirects to users page" do
        post :create, params: { phone: '1234567890', password: 'password' }
        expect(response).to redirect_to users_path
      end
    end

    context "with invalid phone and password" do
      it "redirects to login page" do
        post :create, params: { phone: '1234567890', password: 'invalidpass' }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @user = create(:user)
    end

    it "removes user_id from session variables" do
      delete :destroy, params: { id: @user }
      expect(session[:user_id]).to eq(nil)
    end

    it "redirects to store index page" do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to home_path
    end
  end
end