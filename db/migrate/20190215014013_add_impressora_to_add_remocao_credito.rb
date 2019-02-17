class AddImpressoraToAddRemocaoCredito < ActiveRecord::Migration[5.2]
  def change
    add_reference :remocao_creditos, :impressora, foreign_key: true
  end
end
