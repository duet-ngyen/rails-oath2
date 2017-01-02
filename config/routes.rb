Rails.application.routes.draw do
  get '/api' => redirect('/api/swagger/dist/index.html?url=/api-docs.json')
  namespace :api do
    scope defaults: { format: 'json' } do
      mount_devise_token_auth_for 'User', at: 'auth',controllers: {
          omniauth_callbacks: 'api/omniauth_callbacks',
          registrations: 'api/v1/registrations'
      }

      api_version(module: 'V1', path: {value: 'v1'}) do
        resources :users

        resources :sessions, only: [:create, :destroy]

      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
