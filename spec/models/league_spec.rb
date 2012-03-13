require 'spec_helper'

describe League do

  before(:each) do
    @attr = { :name => "MLS", :year => 2002, :created_by_id => 1 }
  end

  it "should have an user (update_by) field"

  it "should create a new instance given valid attributes" do
    @league = League.create!(@attr)
  end

  it "should require a name" do
    League.new(@attr.merge(:name => "")).should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_league = League.new(@attr.merge(:name => long_name)).should_not be_valid
  end

  it "should require a year" do
    League.new(@attr.merge(:year => nil)).should_not be_valid
  end

  it "should require a year where soccer was played" do
    League.new(@attr.merge(:year => 1250)).should_not be_valid
  end

  it "should require year be a positive number" do
    League.new(@attr.merge(:year => -3)).should_not be_valid
  end

  it "should require year be a number" do
    League.new(@attr.merge(:year => "foo")).should_not be_valid
  end

  it "should require created by id" do
      League.new(@attr.merge(:created_by_id => nil)).should_not be_valid
    end
end