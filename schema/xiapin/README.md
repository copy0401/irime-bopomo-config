# iRime-bopomo-config

## iRime 蝦米輸入法(方案)

---

### xiapin_msc 蝦米簡體方案

### 功能比較單純 純粹碼錶 + 拼音反查 ( 依賴 pinyin_simp 方案)

---

### xiapin_mtc 蝦米繁體方案

### 功能說明

### 1. 造詞功能 
### ( 刪除自造詞方法 : 使用 ```[```  ```]``` 切換候選項 , 
### 再使用 Ctrl+k 或 使用 ```'``` 鍵 刪除自造詞 )


由 ```table_translator```  (~~使用~~ ```;``` ~~引導造詞功能~~ )

改成 

```script_translator``` 帶有造詞功能 及 造句功能 (連打) 

### 2. ```;;``` 反查讀音

### 3. ```;;;``` 拼音輸入法 (依賴 luna_pinyin )

### 4. ```;;;;``` 統一碼(依賴unicode)

### 5. ```;;;;;``` 注音模式輸入 只能查單字/單詞的 蝦米碼 

(使用 = 符號 輸入一聲 ,  依賴 bopomofo_liu ) 

### 6. ```';``` 注音模式輸入  可以連打注音 查蝦米碼 

(使用 = 符號 輸入一聲 ,  依賴 bopomofo_liu )

### 7. ~~使用 ```?``` 符號 當通配符 .~~
~~(例如: 國 oaqe 可以輸入 oa?e / o?e / ?aqe / oaq? )~~

(會導致部署時間太長 暫時停用）

### 8. 頭尾碼 加  ```?``` 符號 ( 例如: 國 oaqe 可以輸入 oe? )

### 9. ```??``` 符號 顯示上屏過的字 ( 使用 Return 或 space 後清除該記錄)

### 反查蝦米碼 使用 ```/opnecc/liu_w2c.json```

### 以上的功能 可能會更改 詳細設定請看  [xiapin_mtc.schema.yaml](https://github.com/copy0401/irime-bopomo-config/blob/master/schema/xiapin/xiapin_mtc.schema.yaml)


---

### 可依需求調整使用的碼表 (修改 liur.extended.dict.yaml  內容)

```yaml
import_tables:
  # - liur_Trad
  # - liur_TradExt
  # - liur_customWords
  # - liur_Japan # 如果要啟動日文漢字就取消註解
  # - liur_TradToSimp # 如果要啟動簡體漢字就取消註解
  - openxiami_TCJP
  # - openxiami_TradExt
  - openxiami_CustomWord # 詞庫
  # - liur_English # 以英語詞庫 小於三碼補 ; 
```

---

### 上述功能參考下列方案

### [shewer/whaleliu](https://github.com/shewer/whaleliu/blob/master/cangjie6liu.schema.yaml)


### [LEOYoon-Tsaw gist](https://gist.github.com/LEOYoon-Tsaw/5786646)

### [hsuanyi-chou/rime-liur](https://github.com/hsuanyi-chou/rime-liur)

### [brianhsu/rime-liur-lua](https://github.com/brianhsu/rime-liur-lua)

### [ianzhuo/rime-liur-lua](https://github.com/ianzhuo/rime-liur-lua)

### [openxiami](https://bit.ly/2OcAvu6)

