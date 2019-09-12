class Locales < Grape::API
  format :json

  params do
    requires :project, type: String
    requires :lang, type: String
    requires :namespace, type: String
  end
  get 'locales/:project/:lang/:namespace' do
    GetTranslation.call(params)
  end

  params do
    requires :project, type: String
    requires :lang, type: String
    requires :namespace, type: String
  end
  post 'locales/:project/:lang/:namespace' do
    AddTranslation.call(params)
  end
end