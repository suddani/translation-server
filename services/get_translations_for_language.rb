class GetTranslationsForLanguage
  def self.call(args)
    new(**Hash[args.map { |k, v| [k.to_sym, v] }]).call
  end

  attr_reader :project,
              :lang,
              :translation_repository

  def initialize(project:, lang:, translation_repository: TranslationRepository.new, context: nil)
    @project = project
    @lang = lang
    @translation_repository = translation_repository
  end

  def call
    translation_repository.where(lang: lang, project: project).reduce({}) do |e, i|
      (e[i.namespace]||=[]) << i
      e
    end
  end
end