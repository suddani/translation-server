class AddTranslation
  def self.call(args)
    new(args).call
  end

  attr_reader :project,
              :lang,
              :namespace,
              :translation,
              :repository

  def initialize(args, repository: TranslationRepository.new)
    @project = args.delete :project
    @lang = args.delete :lang
    @namespace = args.delete :namespace
    @translation = args
    @repository = repository
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
      has_translation = repository.has_translation?(trans)
      puts "Dont add double translations" if has_translation
      repository.persist(trans) unless has_translation
    end
  end
end