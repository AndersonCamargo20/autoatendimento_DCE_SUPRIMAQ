class CreatePrinters < ActiveRecord::Migration[5.2]
  def change
    create_table :printers do |t|
      t.string :model
      t.string :type
      t.float :print_value

      t.timestamps
    end
  end
end
