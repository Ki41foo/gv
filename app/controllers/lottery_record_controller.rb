class LotteryRecordController < ApplicationController
    require 'net/http'
    require 'json'
    
    def index
       
        
        
        @total_count = LotteryRecord.count
        @lottery_records = LotteryRecord.where("result=1").reverse_order
        @bingo_count = @lottery_records.count
        
        
        hhash = LotteryRecord.group("strftime('%H', created_at)").count

        hhash.keys.each {
            |k| hhash[(k.to_i + 8)%24] = hhash.delete(k)
        }
        @hour_data = hhash
        
        @count_data = LotteryRecord.group(:timestamp).count
        
        @signature_data = LotteryRecord.group(:signature).count
        
        hash = LotteryRecord.group(:ti).count
        hash.keys.each {
            |k| hash[LotteryRecordHelper::Mers[k]] = hash.delete(k)
        }
        @detail = hash
        
        @user_count = LotteryRecord.group(:ucode).count
  end
  
  
    
#   def fetch_merchant
#         url = 'http://120.25.150.132/gvhappymacau/merchant/enquire/restaurantandsnack'
#         uri = URI(url)
#         res = Net::HTTP.post_form(uri,'json' => JSON.generate({:ti => "0"}))
#         if(res.body.include? "returnObject")
#             return JSON.parse(res.body)["returnObject"]["list"]
#         else
#             return nil
#         end
#     end
end
