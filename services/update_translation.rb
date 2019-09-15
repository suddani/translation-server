class UpdateTranslation
  def self.call(args)
    new(**Hash[args.map { |k, v| [k.to_sym, v] }]).call
  end

  attr_reader :project,
              :id,
              :value,
              :translation_repository

  def initialize(project:, id:, value:, translation_repository: TranslationRepository.new)
    @project = project
    @id = id
    @value = value
    @translation_repository = translation_repository
  end

  def call
    translation = translation_repository.find(id)
    return unless translation
    translation_repository.update translation.set(value)
  end
end