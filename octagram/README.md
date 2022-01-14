八股文（語法）

配方： ℞ lotem/rime-octagram-data

https://github.com/lotem/rime-octagram-data

Rime 預設詞彙表配套的語言模型。

須裝配Rime插件 librime-octagram。

免責聲明

配方中的文件乃以開放的互聯網語料精煉而成，只供參考之用。 全程自動處理，絕無人工干預。內容如有不妥，製作者不承擔任何責任。

授權條款：見 LICENSE

用法

小狼毫數據包安裝程序

下載 安裝「小狼毫」輸入法 及 語言模型數據包。

修改配置文件

爲輸入方案（以「朙月拼音」爲例）加載語言模型：

```yaml

# luna_pinyin.yaml

__include: grammar:/hant

```

or

```yaml

 luna_pinyin.custom.yaml

patch:
  __include: grammar:/hant

```

若詞典是簡化字的，採用補丁 grammar:/hans ； 

若輸入方案以打單字爲主，即依通常習慣會將詞組分成單字輸入， 

則使用補丁 grammar:/hant_char 或 grammar:/hans_char 。