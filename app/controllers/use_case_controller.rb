class UseCaseController < ApplicationController
  require 'jwt'
  protect_from_forgery prepend: true
  def newUser
    user = User.new
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    if hmac_secret.blank?
      render :json => messageFormatter("Erro de autenticação", 401)
    else
      if hmac_secret != "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21wYW55X2lkIjoxOH0.yRP59sRufpm9ro6RGZ8nuZcfRVMKqkCvneBz6KZB4mU"
        render messageFormatter("Erro de autenticação", 403)
      else
        if request.headers['HTTP_PASSWORD'].blank? || request.headers['HTTP_EMAIL'].blank?  || request.headers['HTTP_NOME'].blank?
          render messageFormatter("Um ou mais parâmetros não foram informados", 404)
        else
          email = request.headers['HTTP_EMAIL']
          nome = request.headers['HTTP_NOME']
          hmac_secret = request.headers['HTTP_AUTHORIZATION']
          password = {
            password: request.headers['HTTP_PASSWORD']
          }
          password_coded = crypteParams(password, hmac_secret)
          other_users_with_email = User.where(email: email)

          if !other_users_with_email.blank?
            other_users_with_email.each do |x|
              puts x.nome
            end
            render messageFormatter("E-mail já cadastrado, informe outro e-mail", 404)
          else
            user = User.create(nome: nome, email: email, password: password_coded, credit: 0, created_at: DateTime.current, updated_at: DateTime.current)
          
            access = {
              email: request.headers['HTTP_EMAIL'],
              session: DateTime.current
            }
            token_access = JWT.encode access, hmac_secret

            render :json => {
              message: "Usuário cadastrado com sucesso!",
              nome: user.nome,
              credito: user.credit,
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
      render :json => messageFormatter("Erro de autenticação", 401)
    else
      if hmac_secret != "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb21wYW55X2lkIjoxOH0.yRP59sRufpm9ro6RGZ8nuZcfRVMKqkCvneBz6KZB4mU"
        render messageFormatter("Erro de autenticação", 403)
      else
        if request.headers['HTTP_PASSWORD'].blank? || request.headers['HTTP_EMAIL'].blank?
          render messageFormatter("Um ou mais parâmetros não foram informados", 404)
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
                email: user.email,
                nome: user.nome,
                credito: user.credit,
                token: token_access
              }, :status => 200
            else
              render messageFormatter("Erro ao tenatr realizar Login, Senha e/ou Email inválidos", 403)
            end
            
          else
            render messageFormatter("Erro ao tenatr realizar Login, Senha e/ou Email inválidos", 403)
          end
        end
      end
    end
  end

  def addCredits
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    access_token = request.headers['HTTP_TOKEN_ACCESS']
    credit = request.headers['HTTP_CREDIT'].to_f
    if hmac_secret.blank?
      render messageFormatter("Erro de autenticação", 401)
    else
      if access_token.blank?
        render messageFormatter("Erro de autenticação", 401)
      else
        if credit.blank?
          render messageFormatter("Um ou mais valores não foram informados, por favor verifique os dados e tente novamente!", 404)
        else
          token_decoded = decryptParams(access_token, hmac_secret)
          date_hour_token = token_decoded[0]['session'].to_datetime
          if date_hour_token >= 15.minute.ago
            user = User.find_by(email: token_decoded[0]['email'])
            if !user.blank?
              user.update(credit: credit + user.credit.to_f)
              render :json => {
                message: "Crédito adicionado com sucesso!",
                email: user.email,
                nome: user.nome,
                credito: user.credit,
                token: access_token
              }, :status => 200
            else
              render messageFormatter("Usuário Inválido, Verifique as informações", 500)  
            end
          else
            render messageFormatter("Sessão encerrada automaticamente após 15 minutis, Por favor refaça o Login", 500)
          end
        end
      end
    end
  end

  def editUser
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    access_token = request.headers['HTTP_TOKEN_ACCESS']
    if hmac_secret.blank?
      render messageFormatter("Erro de autenticação", 401)
    else
      if !request.headers['HTTP_EMAIL'].blank?
        email = request.headers['HTTP_EMAIL']
      end
      if !request.headers['HTTP_PASSWORD'].blank?
        request_password = request.headers['HTTP_PASSWORD']
      end
      if !request.headers['HTTP_NOME'].blank?
        nome = request.headers['HTTP_NOME']
      end
      token_decoded = decryptParams(access_token, hmac_secret)
      date_hour_token = token_decoded[0]['session'].to_datetime
      if date_hour_token >= 15.minute.ago
        user = User.find_by(email: token_decoded[0]['email'])
        if !user.blank?
          user.update(email: email) if !email.blank?
          user.update(nome: nome) if !nome.blank?
          if !request_password.blank?
            password = {
              password: request_password
            }
            password_coded = crypteParams(password, hmac_secret)
            user.update(password: password_coded)
          end
          render :json => {
            message: "Usuário editado com Sucesso!",
            email: user.email,
            nome: user.nome,
            credito: user.credit,
            token: access_token
          }, :status => 200
        else
          render messageFormatter("Usuário Inválido, Verifique as informações", 500)  
        end
      else
        render messageFormatter("Sessão encerrada automaticamente após 15 minutis, Por favor refaça o Login", 500)
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

    def messageFormatter(msg, status)
      return :json => {
        message: msg,
      }, status: status
    end
end
