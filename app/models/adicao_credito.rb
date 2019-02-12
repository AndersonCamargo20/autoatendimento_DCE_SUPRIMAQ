class AdicaoCredito < ApplicationRecord
  belongs_to :empresa
  belongs_to :user
end
