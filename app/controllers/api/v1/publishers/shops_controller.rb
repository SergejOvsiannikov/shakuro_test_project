class Api::V1::Publishers::ShopsController < Api::V1::BaseController
  def index
    shops = publisher.shops.w_sales_count_ordered

    render json: shops, publisher: publisher, status: :ok
  end

  private

  def publisher
    @publisher ||= Publisher.find(params[:publisher_id])
  end
end
