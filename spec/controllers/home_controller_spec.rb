require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'anonymous user' do
    before :each do
      # simulation for anonymous user
      login_with nil
    end

    it "should let user see all contest" do
      get :index
      expect( response ).to render_template( :index )
    end

    it "should let user to see all contest" do
      login_with( :user )
      get :index
      expect( response ).to render_template( :index )
    end
  end
end
