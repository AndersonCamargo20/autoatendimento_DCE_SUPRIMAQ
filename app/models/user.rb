class User < ApplicationRecord
    belongs_to :empresa
    
    def admin? 
        admin == true
    end

end
