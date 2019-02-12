class ApplicationController < ActionController::Base
<<<<<<< HEAD
    require 'uri'

    
=======
>>>>>>> a3a2671da553b47c2a1031b6dad307bf7d2389d5
    def testAuthorization(secret)
        secret == "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21wYW55X2lkIjoxOH0.yRP59sRufpm9ro6RGZ8nuZcfRVMKqkCvneBz6KZB4mU"
    end

<<<<<<< HEAD
    #def crypteParams(obj, hmac_secret)
    #    JWT.encode obj, hmac_secret, 'HS256'
    #end

    def decryptParams(obj, hmac_secret)
        JWT.decode obj, nil, false
    end

    #def messageFormatter(msg, status)
    #    return :json => {
    #        message: msg,
    #    }, status: status
    #end

    #def logado?(date_hour)
    #    date_hour >= 15.minutes.ago
    #end
=======
    def crypteParams(obj, hmac_secret)
        JWT.encode obj, hmac_secret, 'HS256'
    end
  
    def decryptParams(obj, hmac_secret)
        JWT.decode(obj, hmac_secret, true, algorithm: 'HS256')
    end
  
    def messageFormatter(msg, status)
        return :json => {
            message: msg,
        }, status: status
    end

    def logado?(date_hour)
        date_hour >= 15.minutes.ago
    end
>>>>>>> a3a2671da553b47c2a1031b6dad307bf7d2389d5
end
