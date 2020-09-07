class BookingsController < ApplicationController

  def index
    @booking = Booking.new
    @bookings = Booking.ordered
  end

  def create
    bookings = Booking.book(valid_params)
    if bookings[:notice]
      flash[:info] = bookings[:notice]
    else
      flash[:alert] = bookings[:error]
    end
    redirect_to bookings_path
  end

  def destroy
    booking = Booking.find(params[:id])
    booking.destroy
    redirect_to bookings_path
  end

  private

  def valid_params
    params.require(:booking).permit(:name, :persons, :time)
  end
end
