# $ rails g model Order num recipient tel address note:text user:belongs_to state paid_at:datetime transaction_id
# orders資料表 存放 訂單 資料

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :num # 雖然已經有order_id，但不想被猜出有多少訂單，所以還是另外再建一個 訂單編號 欄位
      t.string :recipient # 收件人
      t.string :tel 
      t.string :address
      t.text :note # 備註
      t.belongs_to :user, null: false, foreign_key: true # 哪個使用者下的訂單
      t.string :state, default: 'pending' # 到時會用AASM控管訂單狀態 目前預設狀態 為 處理中
      t.datetime :paid_at
      t.string :transaction_id # 交易成功時會有 transaction id 刷退時需要用到

      t.timestamps
    end
  end
end

# rails db:migrate
# -- create_table(:orders)
#    -> 0.0130s