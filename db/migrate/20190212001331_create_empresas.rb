class CreateEmpresas < ActiveRecord::Migration[5.2]
  def change
    create_table :empresas do |t|
      t.string :nome
      t.float :preco_incolor
      t.float :preco_colorida

      t.timestamps
    end
  end
end
