class AddTranslation
  def self.call(args)
    new(args).call
  end

  attr_reader :project,
              :lang,
              :namespace,
              :translation,
              :translation_repository

  def initialize(args, translation_repository: TranslationRepository.new)
    @project = args.delete :project
    @lang = args.delete :lang
    @namespace = args.delete :namespace
    @translation = args
    @translation_repository = translation_repository
  end

  def call
    translation.each do |key, value|
      next if key == '_t'
      trans = Translation.new(
        project: project,
        lang: lang,
        namespace: namespace,
        key: key,
        hint: value
      )
      translation_repository.persist(trans)
    end
  end
end