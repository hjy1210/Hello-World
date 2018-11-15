## 初體驗
跟隨 [Solr Tutorial](http://lucene.apache.org/solr/guide/7_5/solr-tutorial.html) 的三個練習，對 Solr 有了初步的認識。

## 實作
### 一、準備新的設定 `yh`
先將目錄 `d:\solr-7.5.0\server\solr\configsets\sample_techproducts_configs` 複製到目錄 `d:\solr-7.5.0\server\solr\configsets\yh`。接著參考 [Synonym Graph Filter](http://lucene.apache.org/solr/guide/7_5/filter-descriptions.html#filter-descriptions) 的語法說明，將新目錄裡的 conf\synonyms.txt 的尾巴增加四行
```
# 同形異碼
㈻,學
林,林
㆙,甲
```
新的設定集叫做 `yh`，可以在產生文件集(collection)的時候使用。
### 二、初始具有文件集的 SolrCloud
用下列指令初始 SolrCloud
```
.\bin\solr -e cloud
```
執行期間，為了用 `yh` 設定集來產生新的 `AllSortOfDocuments` 文件集 。回應 `name for your new collection` 時填上 `AllSortOfDocuments`,回應 `choose a configuration for the AllSortOfDocuments collection` 時填上 `yh`。

下面做法沒法初始 SolrCloud，應了解是何緣故？
```
md d:\yh\cloud\node1\solr
md d:\yh\cloud\node2\solr
copy server\solr\solr.xml d:\yh\cloud\node1\solr
copy server\solr\solr.xml d:\yh\cloud\node2\solr
.\bin\solr.cmd start -c -p 8983 -s d:\yh\cloud\node1\solr
.\bin\solr.cmd start -c -p 7574 -s d:\yh\cloud\node2\solr -z localhost:9983
```


### 三、用 PostTool 為文件集加入文件
AllSortOfDocuments文件集已經採用 yh設定集，用下列指令將 d:\AllSortOfDocuments 裡面的檔案萃取資料變成文件加入文件集。
```
java -jar -Dc=AllSortOfDocuments -Dauto -Drecursive=yes example\exampledocs\post.jar d:\AllSortOfDocuments
```
post.jar 的語法可用下列指令來了解
```
java -jar example\exampledocs\post.jar -help
```
### 四、關掉 SolrCloud

```
bin\solr stop -all
```
### 五、重啟 Solr
用下列指令中心啟動 Solr
```
.\bin\solr start -c -p 8983 -s example\cloud\node1\solr
.\bin\solr start -c -p 7574 -s example\cloud\node2\solr -z localhost:9983
```
### 六、新增使用指定設定集的文件集
用下列指令新增使用 sample_techproducts_configs 設定集的 techproducts 文件集，並將 exampleDocs 目錄裡的檔案匯入
```
bin\solr create -c techproducts -d server\solr\configsets\sample_techproducts_configs -s 2 -rf 2
java -jar -Dc=techproducts -Dauto -Drecursive=yes example\exampledocs\post.jar example\exampledocs

```
### 七、新增使用預設設定集的文件集
```
bin\solr create -c films -s 2 -rf 2
```
用 curl 修改設定比用 Admin UI 更有彈性。參考 [Schema API](http://lucene.apache.org/solr/guide/7_5/schema-api.html)，用下列指令新增欄位`name`，複製欄位`＿text_`，並將 `example\films\*.json` 裡面的文件匯入。
```
curl -X POST -H "Content-type:application/json" --data-binary "{\"add-field\": {\"name\":\"name\", \"type\":\"text_general\", \"multiValued\":false, \"stored\":true}}" http://localhost:8983/solr/films/schema

curl -X POST -H "Content-type:application/json" --data-binary "{\"add-copy-field\" : {\"source\":\"*\",\"dest\":\"_text_\"}}" http://localhost:8983/solr/films/schema

java -jar -Dc=films -Dauto example\exampledocs\post.jar example\films\*.json
```
### 八、修改 managed-schema
將 yh設定集的 managed-schema 檔案中
```
<fieldType name="text_general" class="solr.TextField" positionIncrementGap="100">
      <analyzer type="index">
```
裡面的開頭增加
```
<charFilter class="solr.MappingCharFilterFactory" mapping="mapping-FoldToASCII.txt" />
```
以及 mapping-FoldToASCII.txt 檔案的尾巴增加
```
# 同形異碼
"㈻" => "學"
```
如此在 index 過程的開頭就把"㈻"轉成"學"，search 時就可用"數學"找到"數㈻"。

後續必須蒐集更多的同形異碼字，用上面的方法來轉換比用synonyms.txt更穩當。

接著必須把 AllSortOfDocuments 重新索引
```
bin\solr delete -c AllSortOfDocuments
bin\solr create -c AllSortOfDocuments -d server\solr\configsets\yh -s 2 -rf 2
java -jar -Dc=AllSortOfDocuments -Dauto -Drecursive=yes example\exampledocs\post.jar d:\AllSortOfDocuments

```
### 八、雜項

```
bin\solr create -help
bin\solr delete -help
bin\solr delete -c films
rem delete all lucene documents in collection techproducts
java -Ddata=args -Dc=techproducts -jar example\exampledocs\post.jar "<delete><query>*:*</query></delete>"

```

## 疑問
```
synonyms.txt已有
# 同形異碼
㈻,學
林,林
㆙,甲

片語的同義字"林妙香"可，"數學"不可，原因？可能原因：Character.isLetter(㈻)==false。所以應該利用charFilter把"㈻"轉成"學"

```
## 2015000042.pdf
2015000042.pdf 需要用FontPack1900820071_XtdAlf_Lang_DC.msi安裝字形才能閱覽。

\uf9f4妙香研究員\u6797妙香ㆴ