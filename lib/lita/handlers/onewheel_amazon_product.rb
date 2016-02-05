require 'nokogiri'
require 'rest-client'

module Lita
  module Handlers
    class OnewheelAmazonProduct < Handler
      route /(http.*amazon.com\/.*\/dp\/.*)\?*/i, :get_amazon_product

      def get_amazon_product(response)
        description = ''
        price = 0
        uri = response.matches[0][0]
        doc = RestClient.get uri

        Lita.logger.debug doc
        noko_doc = Nokogiri::HTML doc
        noko_doc.xpath('//meta').each do |meta|
          attrs = meta.attributes
          if attrs['name'].to_s == 'description'
            description = process_description attrs['content'].to_s
          end
        end

        price_node = noko_doc.css('span#priceblock_ourprice').first.content

        unless description.empty?
          response.reply price_node.to_s + ' ' + description.to_s
        end
      end

      def process_description(desc)
        desc.sub! /^Amazon.com: /, ''
        desc.sub! /:.*$/, ''
      end

      Lita.register_handler(self)
    end
  end
end
