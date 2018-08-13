class UseCaseController < ApplicationController
  require 'jwt'
  protect_from_forgery prepend: true
  def newUser
    user = User.new
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    if hmac_secret.blank?
      render :json => "Unauthorized", :status => 401
    else
      if hmac_secret != "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21wYW55X2lkIjoxOH0.yRP59sRufpm9ro6RGZ8nuZcfRVMKqkCvneBz6KZB4mU"
        render :json => "Forbiden_Autorization", :status => 403
      else
        if request.headers['HTTP_PASSWORD'].blank? || request.headers['HTTP_EMAIL'].blank?  || request.headers['HTTP_NOME'].blank?
          render :json => "Not Found", :status => 404
        else
          email = request.headers['HTTP_EMAIL']
          nome = request.headers['HTTP_NOME']
          hmac_secret = request.headers['HTTP_AUTHORIZATION']
          password = {
            password: request.headers['HTTP_PASSWORD']
          }
          password_coded = crypteParams(password, hmac_secret)
          other_users_with_email = User.where(email: email).count
          if other_users_with_email.size > 0
            render :json => "Email_já_cadastrado", :status => 404
          else
            user = User.create(nome: nome, email: email, password: password_coded, credit: 0, created_at: DateTime.current, updated_at: DateTime.current)
          
            access = {
              email: request.headers['HTTP_EMAIL'],
              session: DateTime.current
            }
            token_access = JWT.encode access, hmac_secret

            render :json => {
              message: "Usuário cadastrado com sucesso!",
              token: token_access
            }, :status => 200
          end
        end
      end
    end
  end
  
  def loginUser
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    if hmac_secret.blank?
      render :json => "Unauthorized", :status => 401
    else
      if hmac_secret != "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21wYW55X2lkIjoxOH0.yRP59sRufpm9ro6RGZ8nuZcfRVMKqkCvneBz6KZB4mU"
        render :json => "Forbiden_Autorization", :status => 403
      else
        if request.headers['HTTP_PASSWORD'].blank? || request.headers['HTTP_EMAIL'].blank?
          render :json => "Not Found", :status => 404
        else
          email = request.headers['HTTP_EMAIL']
          request_password = request.headers['HTTP_PASSWORD']
          user = User.find_by(email: email)
          if !user.nil?
            password_token = {
              password: user.password
            }
            user_password_decoded = decryptParams(user.password, hmac_secret)
            if user_password_decoded[0]['password'] == request_password
              access = {
                email: request.headers['HTTP_EMAIL'],
                session: DateTime.current
              }
              token_access = JWT.encode access, hmac_secret
              render :json => {
                message: "Login efetuado com sucesso!",
                token: token_access
              }, :status => 200
            else
              render :json => "Invalid_User", :status => 404
            end
            
          else
            render :json => "User_Not_Found_with_the_Email", :status => 404
          end
        end
      end
    end
  end

  private
    def crypteParams(obj, hmac_secret)
      JWT.encode obj, hmac_secret
    end

    def decryptParams(obj, hmac_secret)
      JWT.decode(obj, hmac_secret)
    end
end
