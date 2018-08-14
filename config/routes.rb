Rails.application.routes.draw do
  get  "/newUser"       => "use_case#newUser",      :as => :newUser
  post "/loginUser"     => "use_case#loginUser",    :as => :loginUser
  post  "/addCredits"    => "use_case#addCredits",  :as => :addCredits
  post  "/editUser"      => "use_case#editUser",    :as => :editUser
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
