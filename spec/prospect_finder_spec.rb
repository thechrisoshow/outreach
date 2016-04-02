require 'spec_helper'

describe Outreach::ProspectFinder do

  subject do
    Outreach::ProspectFinder.new(Outreach::Request.new)
  end

  describe 'all' do

    it 'parses correctly' do
      url = "https://api.outreach.io/1.0/prospects"
      stub_get_request(url, 'prospects.json')

      result = subject.all

      expect(result.count).to eq(2)

      first_result = result[0]
      expect(first_result.class).to eq(Outreach::Prospect)
      expect(first_result.first_name).to eq("Chris")
      expect(first_result.last_name).to eq("O'Sullivan")
      expect(first_result.company.name).to eq("Lexoo")
      expect(first_result.contact.phone.work).to be_nil
      expect(first_result.tags).to include("SME")
    end
  end
end
