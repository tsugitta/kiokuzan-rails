Rails.application.routes.draw do
  root 'records#root'
  resources :records
end
