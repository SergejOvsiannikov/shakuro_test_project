class Api::V1::Publisher::ShopsController < Api::V1::BaseController
  before_action :publisher_presence

  def index
    shops = Shop.for_publisher(publisher).uniq

    render json: shops, publisher: publisher, status: 200
  end

  private

  def publisher
    @publisher ||= Publisher.find_by(id: params[:publisher_id])
  end

  def publisher_presence
    unless params[:publisher_id].present?
      render json: { result: 'error', message: 'publisher_id must be present' }, status: 404
      return
    end

    unless publisher.present?
      render json: { result: 'error', message: "publisher with #{params[:publisher_id]} not found" }, status: 404
    end
  end
end

# for a specific Publisher it should return the list of shops selling at least one book of that publisher.
#   Shops should be ordered by the number of books sold. Each shop should include the list of
#   Publisher’s books that are currently in stock.

# {
#   shops:[
#    {
#      “id”: 1,
#      “name”: “Amazon”,
#      “books_sold_count”: 10,
#      “books_in_stock”: [
#        {
#          “id”: 2,
#          “title”: “Yiddish songs”,
#          “copies_in_stock”: 3
#        },
#        …
#      ]
#    },
#    …
#  ]
# }
