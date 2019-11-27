Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :publishers, only: [] do
        scope module: :publishers do
          resources :shops, only: [:index]
        end
      end

      resources :shops, only: [] do
        scope module: :shops do
          resources :books, only: [] do
            scope module: :books do
              resource :mark_as_sold, only: [:create]
            end
          end
        end
      end
    end
  end
end
