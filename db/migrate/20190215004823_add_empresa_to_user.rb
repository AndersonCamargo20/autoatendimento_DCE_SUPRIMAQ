class AddEmpresaToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :empresa, foreign_key: true
  end
end
