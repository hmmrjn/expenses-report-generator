Rails.application.routes.draw do
  root 'groups#index'
  get 'analitics/index'
  get 'groups/:id/download_excel' => 'groups#download_excel'
  get 'groups/:id/download_sums_excel' => 'groups#download_sums_excel'
  get 'sub_groups/:id/download_csv' => 'sub_groups#download_csv'
  get 'sub_groups/:id/download_excel' => 'sub_groups#download_excel'
  get 'expenses/download_csv' => 'expenses#download_csv'
  get 'expenses/download_excel' => 'expenses#download_excel'
  get 'expenses/download_sums_excel' => 'expenses#download_sums_excel'
  resources :expenses
  resources :sub_groups
  resources :groups
  delete 'sub_groups/:id/expenses' => 'sub_groups#destroy_all_expenses'
  resources :sub_categories
  resources :categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
