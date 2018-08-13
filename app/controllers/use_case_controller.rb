class UseCaseController < ApplicationController
  require 'jwt'
  def newUser
    user = User.new
    if request.headers['HTTP_AUTHORIZATION'].blank?
      render :json => "Unauthorized", :status => 401
    else
      if request.headers['HTTP_AUTHORIZATION'] != "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21wYW55X2lkIjoxOH0.yRP59sRufpm9ro6RGZ8nuZcfRVMKqkCvneBz6KZB4mU"
        render :json => "Forbiden_Autorization", :status => 403
      else
        if request.headers['HTTP_PASSWORD'].blank? || request.headers['HTTP_EMAIL'].blank?  || request.headers['HTTP_NOME'].blank?
          render :json => "Not Found", :status => 404
        else
          hmac_secret = request.headers['HTTP_AUTHORIZATION']
          
          

          password = {
            password: request.headers['HTTP_PASSWORD']
          }


          password_coded = crypteParams(password, hmac_secret)
          user = User.create(nome: request.headers['HTTP_NOME'], email: request.headers['HTTP_EMAIL'], password: password_coded, credit: "0", created_at: DateTime.current, updated_at: DateTime.current)
          
          access = {
            email: request.headers['HTTP_EMAIL'],
            password: password_coded,
            session: DateTime.current
          }
          token_access = JWT.encode access, hmac_secret

          render :json => access, :status => 200
        end
      end
    end
  end

  def crypteParams(obj, hmac_secret)
    JWT.encode obj, hmac_secret
  end

  def decryptParams(obj, hmac_secret)
    JWT.decode(obj, hmac_secret)
  end
end
