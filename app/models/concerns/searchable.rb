module Concerns
  module Searchable
    def index
      SearchService.instance.index(self)
    end

    def self.included(klass)
      klass.send(:after_save, :index)
    end
  end
end