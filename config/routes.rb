Rails.application.routes.draw do
  get "/newUser"       => "use_case#newUser",      :as => :newUser
  post "/loginUser"    => "use_case#loginUser",    :as => :loginUser
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
