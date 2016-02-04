require 'spec_helper'

def mock_fixture(fixture)
  mock = File.open("spec/fixtures/#{fixture}.html").read
  allow(RestClient).to receive(:get) { mock }
end

describe Lita::Handlers::OnewheelAmazonProduct, lita_handler: true do
  it 'puts the amazon product info on the response' do
    mock_fixture('sample')
    send_message ('http://www.amazon.com/Plugable-Micro-B-Ethernet-Raspberry-AX88772A/dp/B00RM3KXAU/')
    expect(replies.last).to eq('$13.95 Amazon.com: Plugable USB 2.0 OTG Micro-B to 10/100 Fast Ethernet Adapter for Windows Tablets & Raspberry Pi Zero (ASIX AX88772A chipset): Computers & Accessories')
  end
end
