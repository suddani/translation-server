class TranslationRepository
  # class Model < Sequel::Model(:translations); end
  def self.translations
    @translations ||= {}
  end

  def initialize()
  end

  def persist(translation)
    puts "Persisting: #{translation.lang}[#{translation.namespace}.#{translation.key}] => #{translation.hint}"
    new_id = Database.conn.with do |db|
      db[:translations].insert(translation.as_json(without_translation: true))
    end
    Translation.new(translation.as_json.merge(id: new_id))
  end

  def has_translation?(translation)
    Database.conn.with do |db|
      db[:translations].where(
        project: translation.project,
        lang: translation.lang,
        namespace: translation.namespace,
        key: translation.key
      ).count
    end > 0
  end

  def update(translation)
    Database.conn.with do |db|
      db[:translations].
      where(id: translation.id).
      update(translation.as_json(
        without_primary: true,
        without_translation: true))
    end
  end

  def find(id)
    Database.conn.with do |db|
      out = db[:translations].first(id: id)
      return nil unless out
      Translation.new out
    end
  end

  def where(project:, lang:)
    Database.conn.with do |db|
      db[:translations].where(
        project: project,
        lang: lang
      ).map(&Translation.method(:new))
    end
  end

  def groups(project:)
    Database.conn.with do |db|
      db[:translations].where(
        project: project
      ).select_group(:lang, :namespace)
    end.all.reduce({}) do |all, entry|
      (all[entry[:lang]] ||= []) << entry[:namespace]
      all
    end
  end

  def retrieve(project:, lang:, namespace:)
    active_translations = Database.conn.with do |db|
      db[:translations].where(
        project: project,
        lang: lang,
        namespace: namespace,
        active: true
      ).map(&Translation.method(:new)).map do |t|
        [t.key, t]
      end
    end
    inactive = Database.conn.with do |db|
      db[:translations].where(
        project: project,
        lang: lang,
        namespace: namespace,
        active: false
      ).map(&Translation.method(:new)).map do |t|
        [t.key, t]
      end
    end
    Hash[inactive].merge(Hash[active_translations]).map do |key, t|
      t
    end
  end
end