module DataStoreTypes
  module Container

    module Storage
      def subcontainer=(container)
        @container= container
      end

      def subcontainer(container=nil)
        container ? @container = container : @container
      end

      def key(keys=nil)
        keys ? @keys = keys : @keys
      end
    end

    def self.included(mod)
      mod.extend Storage
    end

    def translations
      @translations ||= {}
    end

    def <<(translation)
      if self.class.subcontainer
        (translations[translation.__send__(self.class.key)]||=self.class.subcontainer.new) << translation
      else
        translations[translation.__send__(self.class.key)] = translation
      end
    end

    def select(key)
      if self.class.subcontainer
        (translations[key]||=self.class.subcontainer.new)
      else
        translations[key]
      end
    end

    def all
      translations.values
    end

    def as_json(opts={})
      translations
    end
    
    def to_json(opts={})
      as_json(opts).to_json(opts)
    end
  end

  class Namespace
    include Container
    key :key
  end

  class Language
    include Container
    subcontainer Namespace
    key :namespace
  end
  class Project
    include Container
    subcontainer Language
    key :lang
  end
end