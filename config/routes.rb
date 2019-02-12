Rails.application.routes.draw do
  post  "/newUser"       => "use_case#newUser",           :as => :newUser
  post  "/loginUser"     => "use_case#loginUser",         :as => :loginUser
  post  "/addCredits"    => "use_case#addCredits",        :as => :addCredits
  post  "/editUser"      => "use_case#editUser",          :as => :editUser
  get   "/allUsers"      => "use_case#returnAllUsers",    :as => :returnAllUsers
  get   "/admin"         => "use_case#setAdmin",          :as => :setAdmin
  post  "/refreshUser"       => "use_case#refreshUser",   :as => :refreshPage
  #get   "/refresh"       => "use_case#refreshPage",       :as => :refreshPage
  get   "/print"         => "use_case#printerPage",       :as => :printerPage
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
