module Outreach
  class Prospect
    attr_accessor :first_name, :last_name, :company, :contact, :tags, :id

    def initialize(attrs)
      @first_name = attrs['attributes']['personal']['name']['first']
      @last_name = attrs['attributes']['personal']['name']['last']
      @company = to_ostruct(attrs['attributes']['company'])
      @contact = to_ostruct(attrs['attributes']['contact'])
      @tags = attrs['attributes']['metadata']['tags']
      @id = attrs['id']
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
end

