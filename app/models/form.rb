class Form < ActiveRecord::Base
  belongs_to :subcategory
  has_many :images, :as => :imageable do
    def primary
      first(:conditions => {:primary => true})
    end
    def primary_first
      all(:order => "`primary` DESC, updated_at DESC")
    end
  end
  
  validates_presence_of :subcategory, :name, :description
  validates_uniqueness_of :permalink
  validate :retail_price_must_be_more_than_wholesale_price, :wholesale_price_must_be_valid, :retail_price_must_be_valid
  
  attr_protected :id
  attr_readonly :permalink
  
  include Permalink
  before_validation_on_create :update_permalink

  delegate :category, :to => :subcategory

  named_scope :all_active, :conditions => ["active = ?", true], :order => "updated_at DESC"

protected

  def update_permalink
    self.permalink = generate_permalink_for(self, self.name)
  end
  
  def retail_price_must_be_more_than_wholesale_price
    errors.add(:retail_price, "must be greater than the wholesale price") if wholesale_price && retail_price && wholesale_price > retail_price
  end
  
  def wholesale_price_must_be_valid
    errors.add(:wholesale_price, "must be a positive value or blank") if !wholesale_price.blank? && wholesale_price < 0
  end
  
  def retail_price_must_be_valid
    errors.add(:retail_price, "must be a positive value or blank") if !retail_price.blank? && retail_price < 0
  end
end
