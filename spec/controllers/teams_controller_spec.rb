require 'spec_helper'

describe TeamsController do
 render_views

  describe "GET 'new'" do

    before(:each) do
      sign_in Factory(:user)
    end

    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "New Team")
    end
    
  end
  
  describe "GET 'edit'" do
    
    before(:each) do
      @team = Factory(:team)
      sign_in Factory(:user)
    end
    
     it "should be successful" do
      get :edit, :id => @team
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @team
      response.should have_selector("title", :content => "Edit team")
    end
    
  end   
  
  describe "PUT 'update'" do
    before(:each) do
      @team = Factory(:team)
      sign_in Factory(:user)
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :address1 => ""}
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @team, :team => @attr
        response.should render_template('edit')        
      end
      
      it "should have the right title" do
        put :update, :id => @team, :team => @attr
        response.should have_selector("title", :content => "Edit team")
      end
      
    end

    describe "success" do
      before(:each) do
       @attr = { :name => "Austin Aztex", :address1 => "123 Main St.", 
              :address2 => "Apt A", :city => "Austin", :state => "TX",
              :zip => "78704", :phone => "512-123-4567", :website => "http://foo.com", 
              :email => "test@foo.com" }        
      end
      
      it "should change the team's attributes" do
        put :update, :id => @team, :team => @attr
        team = assigns(:team)
        @team.reload
        @team.name.should  == team.name
        @team.address1.should  == team.address1
        @team.address2.should  == team.address2
        @team.city.should  == team.city
        @team.state.should  == team.state
        @team.zip.should  == team.zip
        @team.phone.should  == team.phone
        @team.website.should  == team.website
        @team.email.should  == team.email
      end
      
      it "should redirect to the team show page" do
        put :update, :id => @team, :team => @attr
        response.should redirect_to(team_path(@team))
      end
      
      it "should have a flash message" do
        put :update, :id => @team, :team => @attr
        flash[:success].should =~ /updated/
      end
      
    end


  end
  
 
  
  describe "authentication of team edit/update pages" do

    before(:each) do
      @team = Factory(:team)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @team
        response.should redirect_to(new_user_session_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @team, :team => {}
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

    it "should case insensitive search on heroku"

  end



  describe "GET 'show'" do
  
    before(:each) do
      @user = Factory(:user)
      @team = Factory(:team)
    end
    
    it "should be successful" do
      get :show, :id => @team
      response.should be_success
    end
    
    it "should find the right team" do
      get :show, :id => @team
      assigns(:team).should == @team
    end
    
    it "should have the right title" do
      get :show, :id => @team
      response.should have_selector("title", :content => @team.name)    
    end
    
    it "should include the team's name" do
      get :show, :id => @team
      response.should have_selector("h1", :content => @team.name)
    end
  
  end


  describe "POST 'create'" do
      describe "failure" do

        before(:each) do
        sign_in Factory(:user)
         @attr = { :name => "", :address1 => ""} 
        end

        it "should not create a team" do
          lambda do
            post :create, :team => @attr
          end.should_not change(Team, :count)
        end

        it "should have the right title" do
          post :create, :team => @attr
          response.should have_selector("title", :content => "New Team")
        end

        it "should render the 'new' page" do
          post :create, :team => @attr
          response.should render_template('new')
        end  
        
      end
      
      describe "success" do

        before(:each) do
        sign_in Factory(:user)
         @attr = { :name => "name", :address1 => "123 main"} 
        end

        it "should create a team" do
          lambda do
            post :create, :team => @attr
          end.should change(Team, :count).by(1)
        end

        it "should redirect to the team show page" do
          post :create, :team => @attr
          response.should redirect_to(team_path(assigns(:team)))
        end   
        
        it "should have a flash message" do
          post :create, :team => @attr
          flash[:success].should =~ /Team created successfully/
        end

      end

  end
  
  describe "DELETE 'destroy'" do
    #should require special admin role
  end

end
