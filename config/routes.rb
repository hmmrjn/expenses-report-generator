Rails.application.routes.draw do
  root 'expense_groups#index'
  get 'download' => 'expenses#download'
  resources :expenses
  resources :expense_groups
  delete 'expenses' => 'expenses#destroy_all'
  resources :sub_categories
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
