class Routes < Grape::API
  mount Locales
  mount Translations
  add_swagger_documentation base_path: '/translation'
end