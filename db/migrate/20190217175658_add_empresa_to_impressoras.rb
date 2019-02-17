class AddEmpresaToImpressoras < ActiveRecord::Migration[5.2]
  def change
    add_reference :impressoras, :empresa, foreign_key: true
  end
end
