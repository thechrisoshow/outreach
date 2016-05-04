require 'spec_helper'

describe Outreach::Prospect do

  let(:client) { Outreach::Client.new('api_token')}

  describe 'find' do
    it 'returns a prospect' do
      url = "https://api.outreach.io/1.0/prospects/296"
      stub_get_request(url, 'prospect.json')

      result = client.prospects.find(296)
      expect(result.class).to eq(Outreach::Prospect)
    end
  end

  describe 'find_all' do
    it 'parses correctly' do
      url = "https://api.outreach.io/1.0/prospects"
      stub_get_request(url, 'prospects.json')

      result = client.prospects.find_all

      expect(result.count).to eq(2)

      first_result = result[0]
      expect(first_result.class).to eq(Outreach::Prospect)
      expect(first_result.first_name).to eq("Chris")
      expect(first_result.last_name).to eq("O'Sullivan")
      expect(first_result.company.name).to eq("Lexoo")
      expect(first_result.contact.phone.work).to be_nil
      expect(first_result.tags).to include("SME")
      expect(first_result.id).to eq(296)
    end
  end
end
