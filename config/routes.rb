Rails.application.routes.draw do
  root 'groups#index'
  get 'sub_groups/:id/download_csv' => 'sub_groups#download_csv'
  get 'sub_groups/:id/download_excel_plain' => 'sub_groups#download_excel_plain'
  get 'expenses/download_csv' => 'expenses#download_csv'
  get 'expenses/download_excel_plain' => 'expenses#download_excel_plain'
  get 'expenses/download_sums_excel' => 'expenses#download_sums_excel'
  resources :expenses
  resources :sub_groups
  resources :groups
  delete 'sub_groups/:id/expenses' => 'sub_groups#destroy_all_expenses'
  resources :sub_categories
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
