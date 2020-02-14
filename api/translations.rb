class Translations < Grape::API
  format :json

  namespace 'translations' do
    params do
      requires :project, type: String
    end
    get 'groups/:project' do
      GetTranslationGroups.call(declared(params))
    end

    params do
      requires :project, type: String
      requires :lang, type: String
    end
    get 'groups/:project/:lang' do
      GetTranslationsForLanguage.call(declared(params))
    end



    params do
      requires :project, type: String
      requires :id, type: Integer
      requires :value, type: String
      optional :jwt, type: String
    end
    post ':project/:id' do
      UpdateTranslation.call(declared(params))
    end
  end
end