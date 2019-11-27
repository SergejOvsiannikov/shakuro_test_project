class Api::V1::Shops::Books::MarkAsSoldsController < Api::V1::BaseController
  PARENT_OBJECTS_NAMES = %w[book shop]

  before_action :number_of_copies_presence

  def create
    shop.mark_as_sold!(book, Integer(params[:number_of_copies]))

    render nothing: true, status: :created
  rescue Exceptions::Book::InStockLimitExeeded, ArgumentError => error
    render json: { result: 'error', message: error.message }, status: :forbidden
  end

  private

  PARENT_OBJECTS_NAMES.each do |object_name|
    define_method object_name do
      instance_variable_get("@#{object_name}") ||
      instance_variable_set("@#{object_name}", object_name.camelize.constantize.find(params["#{object_name}_id"]))
    end
  end

  def number_of_copies_presence
    unless params[:number_of_copies].present?
      render json: { result: 'error', message: "number_of_copies param is required" }, status: :not_found
    end
  end

  def record_not_found_message(error)
    if error.message.match(/BooksShop/)
      "Book with id=#{book.id} is not selling in shop with id=#{shop.id}"
    else
      super
    end
  end
end
