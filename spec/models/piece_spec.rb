require 'spec_helper'

describe Piece do
  before(:each) do
    @p = Piece.new(:name => "big face", :description => "some big face sculpture")
  end

  describe "validations" do
    it "should have a price if it is for sale" do
      @p.for_sale = true
      @p.price = nil
      @p.should_not be_valid
    end
  end

  after(:each) do
    Piece.delete_all
  end
end
