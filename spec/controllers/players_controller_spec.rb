require 'spec_helper'

describe PlayersController do
 render_views
 
  describe "GET 'new'" do
    before(:each) do
      sign_in FactoryGirl.create(:user)
    end

    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New Player")
    end
  end

  describe "GET 'edit'" do
    let(:player) do
      sign_in(FactoryGirl.create(:user, :email => FactoryGirl.generate(:email)))
      FactoryGirl.create(:player)
    end
    
     it "should be successful" do
      get :edit, :id => player
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => player
      response.should have_selector("title", :content => "Edit player")
    end
  end

  describe "PUT 'update'" do
    let(:player) do
      sign_in(FactoryGirl.create(:user, :email => FactoryGirl.generate(:email)))
      FactoryGirl.create(:player)
    end
    
    describe "failure" do
      let(:attr) { { :firstname => "", :lastname => "", :position => "" } }

      it "should render the 'edit' page" do
        put :update, :id => player, :player => attr
        response.should render_template('edit')        
      end
      
      it "should have the right title" do
        put :update, :id => player, :player => attr
        response.should have_selector("title", :content => "Edit player")
      end
    end
    
    describe "success" do
      let(:attr) do
        { :firstname => "Jamie", :lastname => "Watson", :position => Player::POSITIONS.values.first,
        :birth_date => "02/10/1978", :nationality => "USA", :height_feet => "5", :height_inches => "8"}
      end
      
      it "should change the player's attributes" do
        put :update, :id => player, :player => attr
        player = assigns(:player)
        player.reload
        player.firstname.should eql(attr[:firstname])
        player.lastname.should eql(attr[:lastname])
        player.position.should eql(attr[:position])
        player.birth_date.should eql(Date.parse(attr[:birth_date]))
        player.nationality.should eql(attr[:nationality])
        player.height.should be_within(0.05).of(1.73)
      end
      
      it "should redirect to the player show page" do
        put :update, :id => player, :player => attr
        response.should redirect_to(player_path(player))
      end
      
      it "should have a flash message" do
        put :update, :id => player, :player => attr
        flash[:success].should =~ /updated/
      end
    end
  end
  
  describe "authentication of player edit/update pages" do
    let(:player) { FactoryGirl.create(:player) }

    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => player
        response.should redirect_to(new_user_session_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => player, :player => {}
        response.should redirect_to(new_user_session_path)
      end
    end
  end  
  
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should handle paging"

    it "should handle sorting"

    it "should handle simple search"
  end

  describe "GET 'show'" do
    let(:player) {FactoryGirl.create(:player)}

    it "should be successful" do
      get :show, :id => player
      response.should be_success
    end
    
    it "should find the right player" do
      get :show, :id => player
      assigns(:player).should == player
    end
    
    it "should have the right title" do
      get :show, :id => player
      response.should have_selector("title", :content => player.firstname)
    end
    
    it "should include the team's player" do
      get :show, :id => player
      response.should have_selector("h1", :content => player.firstname)
    end
    
    it "should roll up playerstats in a league/year calculation for player show page"

    it "should calculate player previous club based on past teamstat or roster."
  end

  describe "POST 'create'" do
      describe "failure" do
        let(:attr) do
          sign_in FactoryGirl.create(:user)
          { :firstname => "", :lastname => "", :position => "" }
        end

        it "should not create a player" do
          lambda do
            post :create, :player => attr
          end.should_not change(Player, :count)
        end

        it "should have the right title" do
          post :create, :player => attr
          response.should have_selector("title", :content => "New Player")
        end

        it "should render the 'new' page" do
          post :create, :player => attr
          response.should render_template('new')
        end   
      end

      describe "success" do
        let(:attr) do
          sign_in FactoryGirl.create(:user)
          { :firstname => "first", :lastname => "last", :position => Player::POSITIONS.values.first, :birth_date => "02/10/1978" }
        end

        it "should create a player" do
          lambda do
            post :create, :player => attr
          end.should change(Player, :count).by(1)
        end

        it "should redirect to the player show page" do
          post :create, :player => attr
          response.should redirect_to(player_path(assigns(:player)))
        end   

        it "should save the player's attributes" do
          post :create, :player => attr
          player = assigns(:player)
          player.birth_date.should_not == nil
        end
        
        it "should have a flash message" do
          post :create, :player => attr
          flash[:success].should =~ /Player created successfully/
        end
      end
  end
  
  describe "DELETE 'destroy'" do
    #should require special admin role
  end
end
