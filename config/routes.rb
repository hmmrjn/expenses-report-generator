Rails.application.routes.draw do
  root 'expenses#index'
  get 'download' => 'expenses#download'
  resources :expenses
  resources :sub_categories
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
