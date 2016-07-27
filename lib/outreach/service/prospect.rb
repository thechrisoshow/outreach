module Outreach
  module Service
    class Prospect
      def initialize(client)
        @request = client.request
      end

      def find(id)
        response = @request.get("#{api_url}/#{id}")
        collection_class.build_from_attributes_hash(response['data'])
      end

      def find_all(attrs={})
        response = @request.get(api_url, filter_attribute_mapping(attrs))
        response['data'].map do |attrs|
          collection_class.build_from_attributes_hash(attrs)
        end
      end

      def update(id, attrs)
        mapped_attrs = update_attribute_mapping(attrs)
        @request.patch(api_url + "/" + id.to_s, mapped_attrs)
      end

      protected

      def api_url
        "https://api.outreach.io/1.0/prospects"
      end

      def collection_class
        Outreach::Prospect
      end

      def filter_attribute_mapping(attrs)
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

      def update_attribute_mapping(attrs)
        result = {
          'data' => {
            'attributes' => {
              'personal' => {},
              'contact' => {}
            }
          }
        }

        if attrs['first_name']
          result['data']['attributes']['personal']['name']['first'] = attrs['first_name']
        end
        if attrs['last_name']
          result['data']['attributes']['personal']['name']['last'] = attrs['last_name']
        end
        if attrs['email']
          result['data']['attributes']['contact']['email'] = attrs['email']
        end
        result
      end
    end
  end
end