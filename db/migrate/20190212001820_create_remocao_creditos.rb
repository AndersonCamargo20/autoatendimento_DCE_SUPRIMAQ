class CreateRemocaoCreditos < ActiveRecord::Migration[5.2]
  def change
    create_table :remocao_creditos do |t|
      t.references :empresa, foreign_key: true
      t.float :valor
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
