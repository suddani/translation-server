puts "hey"
class TranslationRepository
  def self.translations
    @translations ||= []
  end

  def initialize()
  end

  def persist(translation)
    self.class.translations << translation
  end

  def retrieve(project:, lang:, namespace:)
    self.class.translations.select do |translation|
      translation.project == project &&
      translation.lang == lang &&
      translation.namespace == namespace
    end
  end
end