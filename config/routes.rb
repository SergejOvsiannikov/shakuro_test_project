Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Вариант №1
      # resources :publishers, only: [] do
      #   resources :shops, only: [:index], to: 'publishers/shops/mark_as_sold#create'
      # end

      # resources :shops, only: [] do
      #   resources :books, only: [] do
      #     resource :mark_as_sold, only: [:create], to: 'shops/books/mark_as_sold#create'
      #   end
      # end

      # Вариант №2
      namespace :publisher do
        resources :shops, only: [:index]
      end

      namespace :shop do
        namespace :book do
          resource :mark_as_sold, only: [:create]
        end
      end
    end
  end
end
