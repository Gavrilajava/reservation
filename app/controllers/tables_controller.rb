class TablesController < ApplicationController
  def index
    @table = Table.new
    @tables = Table.ordered
  end

  def create
    table = Table.new(valid_params)
    if table.save
      flash[:info] = 'Table succesfully created.'
    else
      flash[:alert] = table.error_messages
    end
    redirect_to tables_path
  end

  def destroy
    table = Table.find(params[:id])
    table.destroy
    redirect_to tables_path
  end

  private

  def valid_params
    params.require(:table).permit(:number, :capacity)
  end
end
