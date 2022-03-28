Rails.application.routes.draw do
  # 基本的にapi開発はapiやv1をurlにつけて管理することが多い
  namespace :api do
    resources :users, only: %i[create]
    resource :session, only: %i[create destroy]
  end
end
