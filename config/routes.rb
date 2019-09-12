class Routes < Grape::API
  mount Locales
  add_swagger_documentation base_path: '/translation'
end