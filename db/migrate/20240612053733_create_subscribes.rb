# rails g model Subscribe email:string:uniq
# uniq為指定index不重複

class CreateSubscribes < ActiveRecord::Migration[6.1]
  def change
    create_table :subscribes do |t|
      t.string :email

      t.timestamps
    end
    add_index :subscribes, :email, unique: true # 在資料庫層級驗證為唯一
  end
end

# rails db:migrate
# -- create_table(:subscribes)
# -> 0.0069s
# -- add_index(:subscribes, :email, {:unique=>true})
# -> 0.0011s
