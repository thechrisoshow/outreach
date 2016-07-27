module Outreach
  class Prospect
    attr_accessor :first_name, :last_name, :company, :contact, :tags, :id

    def initialize(attrs)
      @id = attrs['id']
      @first_name = attrs['first_name']
      @last_name = attrs['last_name']
      @company = attrs['company']
      @contact = attrs['contact']
      @tags = attrs['tags']
    end

    def self.build_from_attributes_hash(attrs)
      result = {}
      result['first_name'] = nested_hash_value(attrs, ['attributes', 'personal',
                                                      'name', 'first'])
      result['last_name'] = nested_hash_value(attrs, ['attributes', 'personal',
                                                     'name', 'last'])
      result['company'] = to_ostruct(attrs['attributes'].fetch('company', {}))
      result['contact'] = to_ostruct(attrs['attributes'].fetch('contact', {}))
      result['tags'] = nested_hash_value(attrs, ['attributes', 'metadata',
                                                'tags'])
      result['id'] = attrs['id']
      new(result)
    end

    private

    def self.to_ostruct(hash)
      o = OpenStruct.new(hash)
      hash.each.with_object(o) do |(k,v), o|
        o.send(:"#{k}=", to_ostruct(v)) if v.is_a? Hash
      end
      o
    end

    def self.nested_hash_value(attrs, keys)
      keys.reduce(attrs) {|m,k| m && m[k] }
    end
  end
end

