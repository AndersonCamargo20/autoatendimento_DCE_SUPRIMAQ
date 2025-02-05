Rails.application.routes.draw do 
  post  "/newUser"          => "use_case#newUser",                 :as => :newUser
  post  "/loginUser"        => "use_case#loginUser",               :as => :loginUser
  post  "/addCredits"       => "use_case#addCredits",              :as => :addCredits
  post  "/removeCredits"    => "use_case#removeCredits",           :as => :removeCredits
  post  "/editUser"         => "use_case#editUser",                :as => :editUser
  post   "/allUsers"        => "use_case#returnAllUsers",          :as => :returnAllUsers
  get   "/admin"            => "use_case#setAdmin",                :as => :setAdmin
  post  "/refreshUser"      => "use_case#refreshUser",             :as => :refreshPage
  #get  "/refresh"         => "use_case#refreshPage",              :as => :refreshPage
  post  "/print"           => "use_case#printerPage",              :as => :printerPage
  post  "/dailyReport"     => "use_case#dailyReport",              :as => :dailyReport
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
