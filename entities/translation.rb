class Translation
  attr_accessor :project,
                :lang,
                :namespace,
                :key,
                :hint,
                :value

  def initialize(opts={})
    opts.each do |key,value|
      __send__("#{key}=", value)
    end
  end

  def translation
    value || hint
  end

  def as_json(opts={})
    {
      project: project,
      lang: lang,
      namespace: namespace,
      key: key,
      hint: hint
    }
  end

  def to_json(opts={})
    as_json(opts).to_json(opts)
  end
end