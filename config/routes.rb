Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html\
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        scope module: :merchants do
          resources 'items', only: %i[index]
        end
      end

      resources :items
    end
  end
end
