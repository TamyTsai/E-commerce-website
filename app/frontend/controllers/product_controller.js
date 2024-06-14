import { Controller } from "stimulus";
import Rails from "@rails/ujs";
// 從 "@rails/ujs" import Rails模組

export default class extends Controller {
    static targets = [ "quantity", "sku", "addToCartButton" ]

    quantity_minus(evt) {
        evt.preventDefault();
        if (q > 1) { // 至少要買一個商品，所以商品數量大於1時，-按鈕才有作用
            this.quantityTarget.value = q - 1;
        }
    }

    quantity_plus(evt) {
        evt.preventDefault();
        let q = Number(this.quantityTarget.value);
        // 抓到data-target屬性值為product.quantity的html輸入框標籤後，將其輸入框之值 轉換為數字
        // q 為輸入框之值（數字）
        this.quantityTarget.value = q + 1;
    }

    add_to_cart(evt) {
        evt.preventDefault();

        // 要先知道要把什麼東西放到購物車（商品代碼、數量、規格）
        let product_id = this.data.get("id");
        // this：這個controller
        // 因為html有：  data-controller="product"  data-product-id="<%= @product.code %>"
        // 所以用this.data.get("id") 就可以抓到id
        let quantity = this.quantityTarget.value;
        let sku = this.skuTarget.value;

        if (quantity > 0) {
            // 打api需要時間，所以開始打的時候要讓「加到購物車」按鈕變成loading狀態不可按
            this.addToCartButtonTarget.classList.add('is-loading');
            // classList.add('類別名稱') 可以幫html元素的class屬性 加 值
            let data = new FormData();
            // 準備一包FormData()
            data.append("id", product_id);
            // 把"id", product_id 丟進剛剛新建的FormData()
            data.append("quantity", quantity);
            data.append("sku", sku);

            // 打api
            Rails.ajax({ // 前端controller透過ajax方法，帶著data使用post方法往某一個地方（api路徑）去打，成功時...，失敗時...
                url: '/api/v1/cart', // 往某個地方打
                data, // ES6寫法，key與value一樣，可以只寫一次
                // data: data, // 要送出的資料（有商品code、數量及sku 的FormData()），送出後後端 就會有 一般的參數或強參數 把他抓下來
                type: 'POST', // 用什麼方式打（html動詞）（大小寫沒差）
                // post 新增
                // dataType: 'json', // 希望伺服器回傳 json格式之檔案回來
                success: resp => { // resp為透過api打後端後 後端透過api回傳的資料
                    // console.log(resp);
                    if (resp.status === 'ok') { // 如果 controller.rb 成功
                        let item_count = resp.items || 0;
                        // 就把 後端傳輸輸過來的資料（json檔）中的item key對應的value 指定給 變數 item_count（沒抓到東西就給0）

                        // 發事件
                        let evt = new CustomEvent('addToCart', { 'detail': { item_count } });
                        // evt 自訂事件
                        // CustomEvent為js內建的類別物件 
                        // 準備一個 名為addToCart 之 物件
                        // 追加物件 （細節）為 'detail': { item_count } （「item_count」為 「item_count: item_count」 的ES6縮寫（key與value相同））
                        // 想要丟item_count出去（廣播item_count的內容 給 所有東西知道 供有興趣的人將此內容抓下來）
                        document.dispatchEvent(evt);
                    }
                },
                error: err => { // 404、路徑找不到、伺服器發生錯誤
                    console.log(err);
                },
                complete: () => { // api打完後 不管成功失敗都要做...
                    this.addToCartButtonTarget.classList.remove('is-loading');
                    // classList.add('類別名稱') 可以幫html元素的class屬性 移除 值
                }
            });
            // import Rails from "@rails/ujs" 的方法
            // 內建的 ujs套件
            // 可接js物件

        }

    }


    // 確定有連到view用的
    // connect() {
    //     console.log('hi');
    // }

    
}