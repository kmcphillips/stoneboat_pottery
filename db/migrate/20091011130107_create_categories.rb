class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :permalink
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
