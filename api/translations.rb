class Translations < Grape::API
  format :json

  namespace 'translations' do
    params do
      requires :project, type: String
    end
    get 'groups/:project' do
      GetTranslationGroups.call(params)
    end
  end
end