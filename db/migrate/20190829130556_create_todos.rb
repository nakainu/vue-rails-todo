class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.string :name, null: false
      t.boolean :is_done, default: false, null: false
      t.time :deadline
      t.references :list, foreign_key: true

      t.timestamps
    end
  end
end
