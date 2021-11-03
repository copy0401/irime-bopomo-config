# iRime-bopomo-config

## iRime 注音輸入法設定

### 由於 iRime 內建輸入法 缺少 注音輸入法 , 主題的部分也缺少 注音鍵盤 , 因此下面的操作包含新增注音輸入法 及 注音鍵盤主題 .

* [IOS iRime App 下載安裝](<https://apps.apple.com/tw/app/irime%E8%BE%93%E5%85%A5%E6%B3%95-%E5%B0%8F%E9%B9%A4%E5%8F%8C%E6%8B%BC%E4%BA%94%E7%AC%94%E9%83%91%E7%A0%81%E8%BE%93%E5%85%A5%E6%B3%95/id1142623977>)

- - -

* 開啓 iRime App 後 點擊 pc_pass_iRime 開啓區網分享功能 （ 讓 PC 可以上傳 設定檔 到 ipad 中 )

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/1_ipad1.jpg)

- - -

* 開啓後的畫面 （ 會顯示區網網址IP 例如: 192.168.xx.xx ）

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/2_ipad2.png)

- - -

* 使用電腦瀏覽器 輸入剛剛的網址 

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/3_pc1.png)

- - -

* 點選 Upload Files 按鈕 上傳設定檔 （ 如果已經存在的檔案 記得先刪除 ）

上傳到 /

bopomo_onion.schema.yaml

bopomo_onion_symbols.yaml

bopomo_onion.extended.dict.yaml

terra_pinyin.schema.yaml

terra_pinyin.dict.yaml

terra_pinyin_onion.dict.yaml

terra_pinyin_onion_add.dict.yaml

phrases.cht.dict.yaml

phrases.chtp.dict.yaml

上傳到 /bulid/

default.yaml 替換 /bulid/default.yaml


![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/4_pc2.png)

- - -

* 移動到 theme/flypy/port 目錄下 刪除(紅色按鈕) 原先的 theme.yaml  ( 這裡以 覆蓋 flypy 主題的方式 爲例 )

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/5_pc3.png)

- - -

* 點選 Upload Files 按鈕 上傳 theme.yaml 設定檔  ( 注音鍵盤的主題 ）

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/6_pc4.png)

- - -

* App 回主畫面 點 Deploy（ 部署 ）

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/7_ipad3.jpg)

- - -

* App 點 theme 設定主題 ( 設定鍵盤樣式 ）

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/8_ipad4.jpg)

- - -

* 選 小鶴  ( 剛剛以修改爲 注音樣式的主題 )

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/9_ipad5.jpg)

- - -

* 設定完成後 輸入法的畫面

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/10_ipad6.png)

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/11_ipad6.png)


- - -

* 自訂主題 (自訂鍵盤樣式) 可以參考以下檔案內容差異 製作出符合自己需求的鍵盤樣式

 [theme/bopomoM/port/theme.yaml](<https://github.com/copy0401/irime-bopomo-config/raw/master/theme/bopomoM/port/theme.yaml>)
 
 [other_theme/flypycc3/port/theme.yaml](<https://github.com/copy0401/irime-bopomo-config/raw/master/other_theme/flypycc3/port/theme.yaml>)
 
 [other_theme/zhuyin/port/theme.yaml](<https://github.com/copy0401/irime-bopomo-config/raw/master/other_theme/zhuyin/port/theme.yaml>)


- - -

* [iRime Github](https://github.com/jimmy54/iRime)

* 本文所使用的注音輸入法 由 [洋蔥](https://github.com/oniondelta) 所製作.

* 本文所使用的嘸蝦米輸入法 由 [ianzhuo](https://github.com/ianzhuo/irime-liur)  所製作.

* 在此感謝 [Rime](https://github.com/rime) 作者 [佛振](https://github.com/lotem) 等人的付出與貢獻 .
