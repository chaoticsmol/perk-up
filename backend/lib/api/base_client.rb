require 'httparty'

module Api
  class BaseClient
    include HTTParty

    private

    def get(path, options = {})
      self.class.get(path, **options)
    end

    def post(path, options = {})
      self.class.post(path, **options)
    end

    def put(path, options = {})
      self.class.put(path, **options)
    end
  end
end