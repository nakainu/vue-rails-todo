class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :name, null: false, length: { maximum: 30 }

      t.timestamps
    end
  end
end
