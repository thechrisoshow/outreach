module Outreach
  class Prospect
    attr_accessor :first_name, :last_name, :company, :contact, :tags

    def initialize(attrs)
      @first_name = attrs['attributes']['personal']['name']['first']
      @last_name = attrs['attributes']['personal']['name']['last']
      @company = to_ostruct(attrs['attributes']['company'])
      @contact = to_ostruct(attrs['attributes']['contact'])
      @tags = attrs['attributes']['metadata']['tags']
    end

    private

    def to_ostruct(hash)
      o = OpenStruct.new(hash)
      hash.each.with_object(o) do |(k,v), o|
        o.send(:"#{k}=", to_ostruct(v)) if v.is_a? Hash
      end
      o
    end
  end

  class ProspectFinder
    API_URL =  "https://api.outreach.io/1.0/prospects"

    def initialize(request)
      @request = request
    end

    def find(id)
      response = @request.get("#{API_URL}/#{id}")
      Prospect.new(response)
    end

    def all(attrs={})
      response = @request.get(API_URL, attribute_mapping(attrs))
      response['data'].map {|attrs| Prospect.new(attrs)}
    end

    private

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

