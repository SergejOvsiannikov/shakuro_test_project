module Exceptions
  module Book
    class InStockLimitExeeded < StandardError
      def message
        'You want to sell more book than we have in stock'
      end
    end
  end
end
