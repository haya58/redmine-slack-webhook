RedmineApp::Application.routes.draw do
  resources :projects, only: [] do
    resource :slack_webhook_settings, only: [:show, :update], path: 'slack_webhook'
  end
end
