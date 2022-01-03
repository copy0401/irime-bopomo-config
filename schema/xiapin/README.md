# iRime-bopomo-config

## iRime 蝦米輸入法(方案)

---

### xiapin_msc 蝦米簡體方案

### 功能比較單純 純粹碼錶 + 拼音反查 ( 依賴 pinyin_simp 方案)

---

### xiapin_mtc 蝦米繁體方案

### 功能說明

### ```;``` 造詞功能 

編出來的蝦米碼 為 前三字首碼+最後一字首碼 

```yaml 

例如:

輸入 caur bp

=> cbbb

輸入法 caur bp wyu

=> cbww

輸入法測試 caur bp wyu  wmbr iaxi

=> cbwi

```

### ```;;``` 反查讀音

### ```;;;``` 拼音輸入法 (依賴 luna_pinyin )

### ```;;;;``` 統一碼(依賴unicode)

### ```;;;;;``` 注音模式輸入 只能查單字/單詞的 蝦米碼 (使用 = 符號 輸入一聲 ,  依賴 bopomofo_liu ) 

### ```';``` 注音模式輸入  可以連打注音 查蝦米碼 (使用 = 符號 輸入一聲 ,  依賴 bopomofo_liu )

### 使用 ```?``` 符號 當通配符 .  ( 例如: 國 oaqe 可以輸入 oa?e / o?e / ?aqe / oaq? )

### 反查蝦米碼 使用 ```/opnecc/liu_w2c.json```

### 以上的 前導符 可能會更改 詳細設定請看  [xiapin_mtc.schema.yaml](https://github.com/copy0401/irime-bopomo-config/blob/master/schema/xiapin/xiapin_mtc.schema.yaml)
