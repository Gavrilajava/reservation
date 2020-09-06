class BookingsController < ApplicationController

  def index
    @bookings = Booking.all
  end

  def create
    bookings = Booking.book(valid_params)
    if bookings[:notice]
      flash[:notice] = bookings[:notice]
    else
      flash[:errors] = bookings[:error]
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
