class Api::V1::Shop::Book::MarkAsSoldsController < Api::V1::BaseController
  PARENT_OBJECTS_NAMES = %w[book shop]

  before_action :book_presence, :shop_presence, :number_of_copies_presence

  def create
    book.mark_as_sold!(shop, Integer(params[:number_of_copies]))

    render nothing: true, status: 201
  rescue ActiveRecord::RecordNotFound
    render json: { result: 'error', message: "Book with current book_id is not selling in current shop" }, status: 404
  rescue Exceptions::Book::InStockLimitExeeded, ArgumentError => error
    render json: { result: 'error', message: error.message }, status: 403
  end

  private

  # ВАРИАНТ №1. Немного метопрограммирования, зато все DRY
  PARENT_OBJECTS_NAMES.each do |object_name|
    define_method object_name do
      instance_variable_get("@#{object_name}") ||
      instance_variable_set("@#{object_name}", object_name.camelize.constantize.find_by(id: params["#{object_name}_id"]))
    end

    define_method "#{object_name}_presence" do
      unless params["#{object_name}_id"].present?
        render json: { result: 'error', message: "#{object_name}_id param is required" }, status: 404
        return
      end

      unless send(object_name).present?
        render json: { result: 'error', message: "#{object_name.camelize} with current #{object_name}_id is not found" }, status: 404
      end
    end
  end

  def number_of_copies_presence
    unless params[:number_of_copies].present?
      render json: { result: 'error', message: "number_of_copies param is required" }, status: 404
    end
  end

  # ВАРИАНТ №2. Все четко и ясно, но в глаза бросается, что методы друг друга дублируют.
  # def shop
  #   @shop ||= Shop.find_by(id: params[:shop_id])
  # end

  # def book
  #   @book ||= Book.find_by(id: params[:book_id])
  # end

  # def book_presence
  #   unless params[:book_id].present?
  #     render json: { result: 'error', message: ':book_id is required' }, status: 404
  #   end

  #   unless book.present?
  #     render json: { result: 'error', message: 'Book with current :book_id not found' }, status: 404
  #   end
  # end

  # def shop_presence
  #   unless params[:shop_id].present?
  #     render json: { result: 'error', message: ':shop_id is required' }, status: 404
  #   end

  #   unless shop.present?
  #     render json: { result: 'error', message: 'Shop with current :shop_id not found' }, status: 404
  #   end
  # end
end
