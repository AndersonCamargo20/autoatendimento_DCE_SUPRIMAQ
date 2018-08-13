class UseCaseController < ApplicationController
  require 'jwt'
  def newUser
    user = User.new
    if request.headers['HTTP_AUTORIZATION'].blank?
      render :json => "Unauthorized", :status => 401
    else
      if request.headers['HTTP_AUTORIZATION'] != "Eb 14548251"
        render :json => "Forbiden_Autorization", :status => 403
      else
        if request.headers['HTTP_PASSWORD'].blank? || request.headers['HTTP_EMAIL'].blank?  || request.headers['HTTP_NOME'].blank?
          render :json => "Not Found", :status => 404
        else
          hmac_secret = request.headers['HTTP_AUTORIZATION']
          access = {
            email: request.headers['HTTP_EMAIL'],
            password: request.headers['HTTP_PASSWORD'],
            autorization: hmac_secret,
            session: DateTime.current
          }

          token_access = JWT.encode access, hmac_secret

          password = {
            password: request.headers['HTTP_PASSWORD']
          }


          password_coded = crypteParams(password, hmac_secret)
          #user.nome = request.headers['HTTP_NOME']
          #user.email = request.headers['HTTP_EMAIL']
          #user.password = hash_params[:password]
          #token_pass = JWT.encode request.headers['HTTP_PASSWORD'], nil, false
          user = User.create(nome: request.headers['HTTP_NOME'], email: request.headers['HTTP_EMAIL'], password: password_coded, credit: "0", created_at: DateTime.current, updated_at: DateTime.current)
          #user.credit = 0
          #user.save
          #return_hash  = [
           # name: user.nome,
            #email: user.email,
            #credit: user.credit,
          #  access_token: token_access
          #]

          #email_decoded = JWT.decode(user.password, hmac_secret, "H256")
          #render :json => return_hash
          render :json => "OK", :status => 200
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
