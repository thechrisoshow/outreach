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

  describe 'update' do
    it 'changes the prospect' do
      url = "https://api.outreach.io/1.0/prospects/99"
      stub_request(:patch, url).to_return(body:
        %Q({
          "data": {
            "type": "Prospect",
            "id": 2763,
            "attributes": {
              "created": "2016-05-17T14:47:54.000Z",
              "updated": "2016-07-27T13:44:01.244Z"
            }
          },
          "meta": {
            "request": "13f96b87-d682-4b7d-81d5-04d985b92d56"
          }
        })
      )

      client.prospects.update(99, 'email' => 'chris@lexoo.co.uk')
      assert_requested(:patch, url) do |req|
        request_body = JSON.parse(req.body)
        request_body['data']['attributes']['contact']['email'] == 'chris@lexoo.co.uk'
      end
    end
  end
end
