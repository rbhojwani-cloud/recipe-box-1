class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.integer :cook_time_minutes
      t.string :difficulty
      t.integer :rating
      t.boolean :favorite

      t.timestamps
    end
  end
end
