import './application.scss';

import '@fortawesome/fontawesome-free/css/all.css'
// 寫簡寫的話（import '@fortawesome/fontawesome-free';），他會去看你這個套件（@fortawesome/fontawesome-free）的package.json檔案 的 main標籤（key）（因為本檔案為js檔） 所對應的 值（value）
// package.json： "main": "js/fontawesome.js",
// 但js/fontawesome.js並沒有引進所有字型、css等 所以還是要手動自己加 寫完整的