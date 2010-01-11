class Subcategory < ActiveRecord::Base
  has_one :image, :as => :imageable, :dependent => :destroy
  has_many :forms
  belongs_to :category

  acts_as_permalink :from => :name
  
  validates_presence_of :category, :name
  
  attr_protected :id

  before_save :deactivate_children

  named_scope :active, :conditions => ["active = ?", true], :order => "name ASC"  
  named_scope :inactive, :conditions => ["active = ?", false], :order => "name ASC"

  def inherited_active?
    self.active? && self.category.inherited_active?
  end

protected

  def deactivate_children
    if self.active_changed? && ! self.active?
      self.forms.each do |form|
        form.update_attribute(:active, false) if form.active?
      end
    end
  end
end
