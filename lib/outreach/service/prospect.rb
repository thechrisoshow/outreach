module Outreach
  module Service
    class Prospect
      def initialize(client)
        @request = client.request
      end

      def find(id)
        response = @request.get("#{api_url}/#{id}")
        collection_class.new(response['data'])
      end

      def find_all(attrs={})
        response = @request.get(api_url, attribute_mapping(attrs))
        response['data'].map {|attrs| collection_class.new(attrs)}
      end

      protected

      def api_url
        "https://api.outreach.io/1.0/prospects"
      end

      def collection_class
        Outreach::Prospect
      end

      def attribute_mapping(attrs)
        if attrs[:first_name]
          attrs["filter[personal/name/first]"] = attrs.delete(:first_name)
        end
        if attrs[:last_name]
          attrs["filter[personal/name/last]"] = attrs.delete(:last_name)
        end
        attrs["filter[contact/email]"] = attrs.delete(:email) if attrs[:email]
        if attrs[:company_name]
          attrs["filter[company/name]"] = attrs.delete(company_name)
        end
        attrs
      end
    end
  end
end