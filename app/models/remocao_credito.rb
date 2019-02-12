class RemocaoCredito < ApplicationRecord
  belongs_to :empresa
  belongs_to :user
end
