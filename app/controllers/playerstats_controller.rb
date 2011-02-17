class PlayerstatsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :destroy]

  def new
    @title = "New Playerstat"
    @game = Game.find(params[:game_id])
    @playerstat = Playerstat.new(:game_id => @game.id, :team_id => params[:team_id])
  end

  def create
    @game = Game.find(params[:playerstat][:game_id])
    @team = Team.find(params[:playerstat][:team_id])
    @playerstat = Playerstat.new(params[:playerstat])
    @playerstat.created_by_id = current_user.id
    if @playerstat.save
      flash[:success] = "Player added to game successfully!"
      redirect_to @game
    else 
      @title = "New Playerstat"
      @playerstat = Playerstat.new()
      @playerstat.game = @game
      @playerstat.team = @team
      render 'new'
    end
  end 

  def destroy
    @playerstat = Playerstat.find(params[:id])
    @playerstat.destroy
    redirect_to @playerstat.game
  end

end
