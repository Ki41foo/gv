class CreateLotteryRecords < ActiveRecord::Migration
  def change
    create_table :lottery_records do |t|
      t.string :ucode
      t.string :uc
      t.string :terminalid
      t.string :signature
      t.string :ti
      t.string :timestamp
      t.string :result

      t.timestamps null: false
    end
  end
end
