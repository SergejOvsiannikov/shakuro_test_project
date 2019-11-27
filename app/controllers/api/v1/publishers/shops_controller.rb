class Api::V1::Publishers::ShopsController < Api::V1::BaseController
  before_action :load_publisher

  def index
    shops = publisher.shops.w_sales_count_ordered

    render json: shops, publisher: publisher, status: :ok
  end

  private

  def publisher
    @publisher ||= Publisher.find(params[:publisher_id])
  end

  def load_publisher
    unless publisher.present?
      render json: { result: 'error', message: "publisher with #{params[:publisher_id]} not found" }, status: :not_found
    end
  end
end
