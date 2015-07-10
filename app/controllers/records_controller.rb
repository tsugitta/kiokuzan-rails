class RecordsController < ApplicationController
  def index
    @three_back_records = ThreeBackRecord.rank_order.limit(1000)
    @five_back_records = FiveBackRecord.rank_order.limit(1000)
    @ten_back_records = TenBackRecord.rank_order.limit(1000)
  end

  def create
    @record = Record.new(record_params)
    if @record.save
      ranking = @record.get_ranking
      all_count = Record.where(type: @record.type).count
      render json: { ranking: ranking, all_count: all_count }
    else
      render json: { errors: @record.errors, status: :unprocessable_entity }
    end
  end

  private
  def record_params
    params[:created_date] = Date.today.strftime("%-m/%-d")
    params.permit(:name, :score, :identity, :hash_value, :type, :created_date)
  end
end
