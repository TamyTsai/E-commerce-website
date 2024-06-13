class Category < ApplicationRecord

    acts_as_paranoid

    acts_as_list
    # 加上acts_as_list後，每新增一筆資料（create action）時，會自動把position寫進去

    # act as list範例
    # class TodoList < ActiveRecord::Base
    #   has_many :todo_items, -> { order(position: :asc) }
    # end

    # class TodoItem < ActiveRecord::Base
    #   belongs_to :todo_list
    #   acts_as_list scope: :todo_list
    #   加上acts_as_list後，每新增一筆todoItem時，會自動把position寫進去
    #   還會根據設定的scope 做一個scope（這邊是跟上一層的todo list），所以判斷的時候不是單純+1 +2而已
    # end

    default_scope { order(position: :asc) }
    # 預設 商品分類撈出來 都要依照position欄位值做由小到大排序
    
    has_many :products
    # 每個分類 可有 很多商品

    validates :name, presence: true
end
