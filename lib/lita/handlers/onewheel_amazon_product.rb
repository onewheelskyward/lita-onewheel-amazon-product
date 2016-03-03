require 'nokogiri'
require 'rest-client'

module Lita
  module Handlers
    class OnewheelAmazonProduct < Handler
      route /([htp:\/]*www.amazon.com\/.*\/*dp\/.*)\?*/i, :get_amazon_product

      def get_amazon_product(response)
        description = ''
        uri = response.matches[0][0]
        Lita.logger.debug "lita-onewheel-amazon-product: Grabbing URI #{uri}"

        counter = 0
        loop do
          doc = RestClient.get uri

          counter += 1
          break if counter == 3 or doc.code == 200
        end


        noko_doc = Nokogiri::HTML doc
        noko_doc.css('meta').each do |meta|
          attrs = meta.attributes
          if attrs['name'].to_s == 'title'
            description = process_description attrs['content'].to_s
          end
        end

        if description.empty?
          Lita.logger.error "lita-onewheel-amazon-product: Processing of #{uri} failed."
          return
        end

        price = get_price(noko_doc)

        unless description.empty?
          response.reply price.to_s + ' ' + description.to_s
        end
      end

      # Getting prices is very non-intuitive, every type of price has it's own structure.
      # Here we keep trying until we get something.
      def get_price(noko_doc)
        price_node = noko_doc.css('span#priceblock_ourprice')
        price = nil

        # Typical product price
        if price_node.empty?
          price_node = noko_doc.css('div#unqualifiedBuyBox .a-color-price')
        end

        # Third-party seller only price
        if price_node.empty?
          price_node = noko_doc.css('div#buyNewSection span.a-color-price')
        end

        # Kindle book price
        if price_node.empty?
          price_node = noko_doc.css('td.dp-price-col span.a-color-price')
        end

        if price_node.empty?
          price_node = noko_doc.css('div#olp_feature_div span.a-color-price')
        end

        unless price_node.empty?
          price = price_node.first.content.to_s
        end

        price
      end

      def process_description(desc)
        desc.sub! /^Amazon.com\s*: /, ''
        desc.sub! /:.*$/, ''
      end

      Lita.register_handler(self)
    end
  end
end
