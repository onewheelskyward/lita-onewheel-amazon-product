require 'spec_helper'

def mock_fixture(fixture)
  mock = File.open("spec/fixtures/#{fixture}.html").read
  allow(RestClient).to receive(:get) { mock }
end

describe Lita::Handlers::OnewheelAmazonProduct, lita_handler: true do
  it 'puts the amazon product info on the response' do
    mock_fixture('our_price')
    send_message ('http://www.amazon.com/Plugable-Micro-B-Ethernet-Raspberry-AX88772A/dp/B00RM3KXAU/')
    expect(replies.last).to eq('$13.95 Plugable USB 2.0 OTG Micro-B to 10/100 Fast Ethernet Adapter for Windows Tablets & Raspberry Pi Zero (ASIX AX88772A chipset)')
  end

  it 'puts the amazon product info on the response when there is no amazon price' do
    mock_fixture('third_party_price')
    send_message ('http://www.amazon.com/Digital-Life-Performance-Ethernet-Cables/dp/B001AE8YBW/')
    expect(replies.last).to eq('$67.30 Digital Life High Performance Ethernet Cables - Advanced High Speed - 7 ft. Advanced High Speed Ethernet Cable')
  end

  it 'puts book price' do
    mock_fixture('book_price')
    send_message ('http://www.amazon.com/Live-Detroit-Without-Being-Jackass/dp/0996836705')
    expect(replies.last).to eq('$15.10 How To Live In Detroit Without Being A Jackass')
  end

  it 'puts kindle-only book price' do
    mock_fixture('kindle_book_price')
    send_message ('http://www.amazon.com/Echo-Billionaire-Romance-Bleeding-Hearts-ebook/dp/B01786HTZW')
    expect(replies.last).to eq('$2.99 Echo')
  end

  it 'puts the price of 55 gallons of lube' do
    mock_fixture('55_gallons_of_lube_price')
    send_message ('http://www.amazon.com/Passion-Lubes-Silicone-Hybrid-Lubricant/dp/B00SZ3O6OU/ref=sr_1_1?ie=UTF8&qid=1454972328&sr=8-1&keywords=lube+drum')
    expect(replies.last).to eq('$1,415.67 Passion Lubes Passion Water and Silicone Blend Hybrid Lubricant, 55 Gallon')
  end

  it 'puts the price of an infant circumcision' do
    mock_fixture('infant_circumcision_price')
    send_message ('http://www.amazon.com/Nasco-Infant-Circumcision-Trainer-White/dp/B0083Y0W26')
    expect(replies.last).to eq('$192.00 Infant Circumcision Trainer, White ')
  end
end
