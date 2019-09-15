class GetTranslation
  def self.call(args)
    new(**Hash[args.map { |k, v| [k.to_sym, v] }]).call
  end

  attr_reader :project,
              :lang,
              :namespace,
              :translation_repository

  def initialize(project:, lang:, namespace:, translation_repository: TranslationRepository.new)
    @project = project
    @lang = lang
    @namespace = namespace
    @translation_repository = translation_repository
  end

  def call
    # raise "Unknown language" if lang == "dev"
    Hash[translation_repository.retrieve(
      project: project,
      lang: lang,
      namespace: namespace).map do |translation|
        [translation.key, translation.translation]
      end]
  end
end