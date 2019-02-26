class CreateImpressoras < ActiveRecord::Migration[5.2]
  def change
    create_table :impressoras do |t|
      t.string :modelo
      t.float :preco
      t.string :tipo

      t.timestamps
    end
  end
end
