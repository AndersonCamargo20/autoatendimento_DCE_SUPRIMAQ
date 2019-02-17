class AddImpressoraToAddCredits < ActiveRecord::Migration[5.2]
  def change
    add_reference :adicao_creditos, :impressora, foreign_key: true
  end
end