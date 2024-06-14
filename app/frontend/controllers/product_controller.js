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
            // classList.add('類別名稱') 可以幫html元素的class屬性加值
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
                    console.log(resp);
                //     switch (response.status){ // 後端回一包json檔案 抓出其中的 status key
                //         case 'ok': // status key 之 value 若等於 ok（表示email寫入資料庫成功）
                //             alert('完成訂閱');
                //             this.emailTarget.value = "";
                //             // 抓到data-target="subscribe.email"的html元素輸入框中的值，將其變成空白（完成訂閱後 清空輸入框）
                //             // this指的是這個function本身 所以會失敗，要把function改成ES6 箭頭函數，這樣作用scope就會不一樣
                //             break;
                //         case '已訂閱過電子報': // status key 之 value 若等於 已訂閱過電子報（表示email寫入資料庫失敗）
                //             alert(`${response.email} 已訂閱過電子報`); // 後端回一包json檔案 抓出其中的 email key
                //             // 後端controller： render json: { status: '已訂閱過電子報', email: email }
                //             break;
                //     }
                },
                error: err => { // 404、路徑找不到、伺服器發生錯誤
                    console.log(err);
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