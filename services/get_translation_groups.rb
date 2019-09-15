class GetTranslationGroups
  def self.call(args)
    new(**Hash[args.map { |k, v| [k.to_sym, v] }]).call
  end

  attr_reader :project,
              :translation_repository

  def initialize(project:, translation_repository: TranslationRepository.new)
    @project = project
    @translation_repository = translation_repository
  end

  def call
    translation_repository.groups(project: project)
  end
end