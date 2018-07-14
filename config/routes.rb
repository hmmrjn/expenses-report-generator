Rails.application.routes.draw do
  root 'expense_groups#index'
  get 'expense_groups/:id/download_csv' => 'expense_groups#download_csv'
  get 'expense_groups/:id/download_excel_plain' => 'expense_groups#download_excel_plain'
  get 'expenses/download' => 'expenses#download'
  resources :expenses
  resources :expense_groups
  delete 'expense_groups/:id/expenses' => 'expense_groups#destroy_all_expenses'
  resources :sub_categories
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
