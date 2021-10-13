2021/10/1 更新後已經有內建 注音輸入法 ( 還是推薦使用 洋蔥注音 )

而適用於注音輸入法的主題 iPadOS不會顯示該主題 ( iOS 能用 )

需要將 /theme/zhuyin/info.yaml  下載

內容 SupportPlatform: iOS  那行修改爲 SupportPlatform: iOS,iPadOS 

刪除 原本的設定檔

上傳 修改後的設定檔

---

以下爲新增主題的流程：

1. iRime App 開啓 pc_pass_iRime

2. 透過 PC 瀏覽器 調整設定檔 ( 刪除/上傳 )

3. 新增資料夾 /theme/bopomo7  
4. 新增資料夾 /theme/bopomo7/port 

5. 上傳檔案 /theme/bopomo7/info.yaml
6. 上傳檔案 /theme/bopomo7/port/theme.yaml

7. 刪除 /SharedSupport/iRime.custom.yaml (原本的)
8. 上傳 /SharedSupport/iRime.custom.yaml (修改後的 只有刪除 空白鍵上顯示"注音" )

9. 刪除 /iRime.custom.yaml ( 原本的 )
10. 上傳 /iRime.custom.yaml ( 修改後的 隱藏用不到的功能 emoji表情 剪贴板历史 )

11. Deploy ( 部署 )

12. Select_schema 選 注音

13. theme 選 bopomo7 ( 注音的主題之一 )

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/Method3_1.jpg)

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/Method3_2.jpg)

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/Method3_3.jpg)

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/Method3_4.jpg)

![](https://github.com/copy0401/irime-bopomo-config/raw/master/images/Method3_5.jpg)
