class UseCaseController < ApplicationController
  protect_from_forgery prepend: true 
  
  require 'jwt'
  require 'net/http'
  require 'json'

  #VERIFICADO 1
  def newUser
    user = User.new
    hmac_secret = request.headers['AUTHORIZATION']
    if hmac_secret.blank?
      render :json => messageFormatter("Erro de autenticação", 401)
    else
      if !testAuthorization(hmac_secret)
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
            render messageFormatter("E-mail já cadastrado, informe outro e-mail", 404)
          else
            user = User.create(nome: nome, email: email, password: password_coded, credit: 0, created_at: DateTime.current, updated_at: DateTime.current)
            access = {
              email: request.headers['HTTP_EMAIL'],
              session: DateTime.current
            }
            token_access = JWT.encode access, hmac_secret, 'HS256'
            @response = []

            @response = {
              message: "Usuário cadastrado com sucesso!",
              nome: user.nome,
              email: user.email,
              admin: user.admin,
              credito: user.credit,
              token: token_access
            }
            render :json => @response, :status => 200
          end
        end
      end
    end
  end
  
  #VERIFICADO 1
  def loginUser
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    if hmac_secret.blank?
      render :json => messageFormatter("Erro de autenticação", 401)
    else
      if !testAuthorization(hmac_secret)
        render messageFormatter("Erro de autenticação", 401)
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
              token_access = JWT.encode access, hmac_secret, 'HS256'
              render :json => {
                message: "Login efetuado com sucesso!",
                email: user.email,
                nome: user.nome,
                admin: user.admin,
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

  #OK
  def addCredits
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    access_token = JSON.parse(request.body.read)
    credit = request.headers['HTTP_CREDIT'].to_f
    emailToAdd = request.headers['HTTP_EMAIL']
    if hmac_secret.blank?
      render messageFormatter("Authorization não informado", 401)
    else
      if !testAuthorization(hmac_secret)
        render messageFormatter("Authorization inválido", 401)
      else
        if access_token.blank?
          render messageFormatter("Access Token não informado", 401)
        else
          token_decoded = decryptParams(access_token["token"].to_s, hmac_secret)
          date_hour_token = token_decoded[0]['session'].to_datetime
          if self.logado?(date_hour_token)
            email_decoded = token_decoded[0]['email']
            current_user = User.find_by(email: email_decoded)
            if current_user && current_user.admin?
              user = User.find_by(email: emailToAdd)
              if !user.blank?
                creditos = user.credit.to_f
                user.update(credit: creditos + credit)
                render :json => {
                  message: "Créditos adicionados com sucesso!",
                  email: user.email,
                  nome: user.nome,
                  admin: user.admin,
                  credito: user.credit,
                  token: access_token['token']
                }, :status => 200
              else
                render messageFormatter("Usuário não existente!", 403)
              end
            else
              render messageFormatter("Usuário não existente ou sem sutorização!", 403)  
            end
          else
            render messageFormatter("Login expirado! Refaça o login", 401)
          end
        end
      end
    end
  end

  #OK
  def editUser
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    access_token = JSON.parse(request.body.read)
    if hmac_secret.blank?
      render messageFormatter("Erro de autenticação", 401)
    else
      if !testAuthorization(hmac_secret)
        render messageFormatter("Authorization inválido", 401)
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
        token_decoded = decryptParams(access_token['token'], hmac_secret)
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
              message: "Impressão realizada com sucesso!",
              email: user.email,
              nome: user.nome,
              admin: user.admin,
              credito: user.credit,
              token: access_token["token"]
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
  
  #OK
  def returnAllUsers
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    access_token = JSON.parse(request.body.read)
    if hmac_secret.blank?
      render messageFormatter("Erro de autenticação", 401)
    else
      if access_token.blank?
        render messageFormatter("Acesso Proibido", 401)
      else
        token_decoded = decryptParams(access_token['token'], hmac_secret)
        date_hour_token = token_decoded[0]['session'].to_datetime
        current_email = token_decoded[0]['email']
        if date_hour_token >= 15.minute.ago
          current_user = User.find_by(email: current_email)
          if !current_user.blank?
            if current_user.admin?
              @users = User.all
              @usersFormatted = []
              @users.each do |user|
                @usersFormatted << {
                  nome: user.nome,
                  email: user.email,
                  credito: user.credit
                }
              end
              render :json => @usersFormatted, status: 200          
            else
              render messageFormatter("Usuário sem autorização para acessar essa funcionalidade", 403)
            end          
          else
            render messageFormatter("Acesso negado, Refaça o login", 500)
          end
        else
          render messageFormatter("Acesso negado, Refaça o login", 500)
        end
      end
    end
  end

  def setAdmin
    email = request.headers['HTTP_EMAIL']
    user = User.find_by(email: email)
    user.update(admin: true)
  end

  #OK
  def printerPage
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    access_token = JSON.parse(request.body.read)
    if hmac_secret.blank?
      render messageFormatter("Erro de autenticação", 401)
    else
      if access_token.blank?
        render messageFormatter("Acesso Proibido", 401)
      else
        if !testAuthorization(hmac_secret)
          render messageFormatter("Authorization inválido", 401)
        else
          token_decoded = decryptParams(access_token['token'], hmac_secret)
          date_hour_token = token_decoded[0]['session'].to_datetime
          current_email = token_decoded[0]['email']
          if date_hour_token >= 15.minute.ago
            current_user = User.find_by(email: current_email)
            if !current_user.blank?
              printer_token = request.headers['HTTP_PRINTER']
              printer = Impressora.find_by(modelo: printer_token.to_s)
              if !printer.blank?
                qtd_pages = access_token['pages']
                print_value = printer.preco.to_f
                value_want_print = qtd_pages.to_f * printer.preco
                if value_want_print.to_f <= current_user.credit.to_f
                  diference = (current_user.credit.to_f - value_want_print.to_f).to_f  
                  current_user.update(credit: diference)
                  render :json => {
                    message: "Impressoão realizada com sucesso!",
                    email: current_user.email,
                    nome: current_user.nome,
                    admin: current_user.admin,
                    credito: current_user.credit,
                    token: access_token['token']
                  }, :status => 200          
                else
                  render messageFormatter("Crédito insuficiente para realizar a impressão!", 401)
                end
              else
                render messageFormatter("A impressero selecionada não existe, impossível realizar a impressão!", 401)
              end
            else
              render messageFormatter("Usuário não existente ou sem sutorização!", 403)  
            end
          else
            render messageFormatter("Sessão encerrada, para continuar realize o login novamente", 403)
          end
        end
      end
    end
  end

  #OK
  def refreshPage
    hmac_secret = request.headers['HTTP_AUTHORIZATION']
    access_token = JSON.parse(request.body.read)
    if hmac_secret.blank?
      render messageFormatter("Authorization não informado", 401)
    else
      if !testAuthorization(hmac_secret)
        render messageFormatter("Authorization inválido", 401)
      else
        if access_token.blank?
          render messageFormatter("Access Token não informado", 401)
        else
          token_decoded = decryptParams(access_token["token"].to_s, hmac_secret)
          date_hour_token = token_decoded[0]['session'].to_datetime
          if self.logado?(date_hour_token)
            email_decoded = token_decoded[0]['email']
            current_user = User.find_by(email: email_decoded)
            if current_user
              render :json => {
                message: "Atualização de status realizada com sucesso",
                email: current_user.email,
                nome: current_user.nome,
                admin: current_user.admin,
                credito: current_user.credit,
                token: access_token['token']
              }, :status => 200
            else
              render messageFormatter("Usuário não existente ou sem sutorização!", 403)  
            end
          else
            render messageFormatter("Login expirado! Refaça o login", 500)
          end
        end
      end
    end
  end

end