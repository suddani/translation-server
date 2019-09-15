class Translation < Dry::Struct
  transform_keys(&:to_sym)

  attribute :project, Types::String
  attribute :lang, Types::String.default('en'.freeze)
  attribute :namespace, Types::String.default('translations'.freeze)
  attribute :key, Types::String
  attribute :hint, Types::String
  attribute :value, Types::String.optional.default(nil)
  attribute :active, Types::Bool.default(false)
  attribute :id, Types::Integer.optional.default(nil)

  def translation
    value || hint
  end

  def as_json(opts={})
    out = to_hash
    out = out.merge(translation: translation) unless opts[:without_translation]
    out.delete(:id) if opts[:without_primary]
    out
  end

  def set(value)
    Translation.new(to_hash.merge(value: value))
  end

  def to_json(opts={})
    as_json(opts).to_json(opts)
  end
end