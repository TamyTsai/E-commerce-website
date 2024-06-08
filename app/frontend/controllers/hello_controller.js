// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    console.log('hi');
    // 一存檔 重新整理網頁 馬上就會生效，因為webpack幫你做 hard reload
    // this.outputTarget.textContent = 'Hello, Stimulus!'
  }
}
