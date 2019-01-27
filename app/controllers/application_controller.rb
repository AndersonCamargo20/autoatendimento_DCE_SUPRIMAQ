class ApplicationController < ActionController::Base
    def testAuthorization(secret)
        secret == "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21wYW55X2lkIjoxOH0.yRP59sRufpm9ro6RGZ8nuZcfRVMKqkCvneBz6KZB4mU"
    end

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
end
