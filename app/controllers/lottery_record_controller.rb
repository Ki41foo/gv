class LotteryRecordController < ApplicationController
    def index
    @total_count = LotteryRecord.count
    @lottery_records = LotteryRecord.where("result=1")
    @bingo_count = @lottery_records.count
    @count_data = LotteryRecord.group(:timestamp).count
    @signature_data = LotteryRecord.group(:signature).count
  end
  
  
end
