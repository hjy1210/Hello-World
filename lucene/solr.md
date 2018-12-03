## Solr 是甚麼？
Solr 是個搜尋伺服器
* 用 Lucene 作搜尋引擎，
* 提供工具產生資料庫所需的文件，
* 以 RESTfull 方式提供各種服務，
* 規模化的 SolrCloud 可應付龐大的資料
## 初體驗
跟隨 [Solr Tutorial V7.5](http://lucene.apache.org/solr/guide/7_5/solr-tutorial.html) 的三個練習，對 Solr 有了初步的認識。

## 基本概念
* [Using the Solr Administration User Interface](http://lucene.apache.org/solr/guide/7_5/using-the-solr-administration-user-interface.html)
* [Documents, Fields, and Schema Design](http://lucene.apache.org/solr/guide/7_5/documents-fields-and-schema-design.html)
* [Understanding Analyzers, Tokenizers, and Filters](http://lucene.apache.org/solr/guide/7_5/understanding-analyzers-tokenizers-and-filters.html)
* [Indexing and Basic Data Operations](http://lucene.apache.org/solr/guide/7_5/indexing-and-basic-data-operations.html)
* [Searching](http://lucene.apache.org/solr/guide/7_5/searching.html)


## 實作
### 一、準備新的設定集 `yh`
先將目錄 `d:\solr-7.5.0\server\solr\configsets\sample_techproducts_configs` 複製到目錄 `d:\solr-7.5.0\server\solr\configsets\yh`，這是新的設定集`yh`，可以在產生文件集(collection)的時候使用。


中文中有些同形異碼字，要處理同形異碼字的問題，
參考[CharFilterFactories](http://lucene.apache.org/solr/guide/7_5/charfilterfactories.html)，將 yh設定集的 managed-schema 檔案中
```
<fieldType name="text_general" class="solr.TextField" positionIncrementGap="100">
      <analyzer type="index">
```
裡面的開頭增加
```
<charFilter class="solr.MappingCharFilterFactory" mapping="mapping-FoldToASCII.txt" />
```
以及 yh\conf\mapping-FoldToASCII.txt 檔案的尾巴增加
```
# 同形異碼
"㈻" => "學"
"林" => "林"
"㆙" => "甲"
```
如此在 index 過程的開頭就把"㈻"轉成"學"，search 時就可用"數學"找到"數㈻"。

前面的 `"林" => "林"` 中左邊的林內碼為\uf9f4而右邊的林為\u6797。前面的 `"㆙" => "甲"` 中左邊的㆙內碼為\u3199而右邊的甲為\u7532。

後續必須蒐集更多的同形異碼字。

因為"㈻"不算字母(Letter)(Character.isLetter(㈻)==false)，而搜尋階段會先去除非字母的字元，故用這種方法來轉換比用synonyms.txt更穩當。

英文中有一些字，如a,the,...，所謂的stopword，在搜尋時不具價值。為了解決這個問題，將 yh\conf\lang\stopwords_en.txt的尾巴的stopword複製到yh\conf\stopwords.txt的尾巴。

英文字中有些字的區別，如單數與複數、現在式與過去式，在檢索時意義不大，這是所謂的stem問題。為了處理英文的 stem 問題，將 yh\conf\managed-schema 中
`<fieldType name="text_general" class="solr.TextField" positionIncrementGap="100">` 的
`<analyzer type="index">`與`<analyzer type="query">` 裡面 `<tokenizer>`的後面都增加 `<filter class="solr.PorterStemFilterFactory"/>`

最後的整個 `<fieldType name="text_general" class="solr.TextField" positionIncrementGap="100">` 變成
```
    <fieldType name="text_general" class="solr.TextField" positionIncrementGap="100">
      <analyzer type="index">
        <charFilter class="solr.MappingCharFilterFactory" mapping="mapping-FoldToASCII.txt" />
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.PorterStemFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <!-- in this example, we will only use synonyms at query time
        <filter class="solr.SynonymGraphFilterFactory" synonyms="index_synonyms.txt" ignoreCase="true" expand="false"/>
        <filter class="solr.FlattenGraphFilterFactory"/>
        -->
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.PorterStemFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>
```

### 二、初始具有文件集的 SolrCloud
用下列指令初始 SolrCloud
```
.\bin\solr -e cloud
```
執行期間，為了用 `yh` 設定集來產生新的 `allsortofdocuments` 文件集 。回應 `name for your new collection` 時填上 `allsortofdocuments`,回應 `choose a configuration for the allsortofdocuments collection` 時填上 `yh`。

上面產生的兩個node的位置為 example\cloud\node1 與 example\cloud\node2。

若要手動初始 SolrCloud，將node的位置放在 d:\yh\cloud\node1\sol與d:\yh\cloud\node2\solr 並產生 allsortofdocuments文件集，可用下列指令
```
md d:\yhcloud\node1\solr
md d:\yhcloud\node2\solr
copy server\solr\solr.xml d:\yhcloud\node1\solr
copy server\solr\solr.xml d:\yhcloud\node2\solr
copy server\solr\zoo.cfg d:\yhcloud\node1\solr
copy server\solr\zoo.cfg d:\yhcloud\node2\solr
.\bin\solr.cmd start -c -p 8983 -s d:\yhcloud\node1\solr
.\bin\solr.cmd start -c -p 7574 -s d:\yhcloud\node2\solr -z localhost:9983
bin\solr create -c allsortofdocuments -d server\solr\configsets\yh -s 2 -rf 2
```


### 三、用 PostTool 為文件集加入文件
allsortofdocuments文件集已經採用 yh設定集，用下列指令將 d:\data\allsortofdocuments 裡面的檔案萃取資料變成文件加入文件集。
```
java -jar -Dc=allsortofdocuments -Dauto -Drecursive=yes example\exampledocs\post.jar d:\data\allsortofdocuments
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
.\bin\solr start -c -p 8983 -s d:\yh\cloud\node1\solr
.\bin\solr start -c -p 7574 -s d:\yh\cloud\node2\solr -z localhost:9983
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

### 八、Solr standard
```
md d:\yhstandalone\solr
copy server\solr\solr.xml d:\yhstandalone\solr
copy server\solr\zoo.cfg d:\yhstandalone\solr
.\bin\solr.cmd start -p 8983 -s d:\yhstandalone\solr
bin\solr create -c allsortofdocuments -d server\solr\configsets\yh
java -jar -Dc=allsortofdocuments -Dauto -Drecursive=yes example\exampledocs\post.jar d:\data\allsortofdocuments
.\bin\solr delete -c allsortofdocuments
java -Ddata=args -Dc=allsortofdocuments -jar example\exampledocs\post.jar "<delete><query>*:*</query></delete>"

bin\solr stop -all

```
### 九、 CORS
solr 提供 RESTfull 服務，若寫網站利用 solr 當後台，必須讓 solr 支援 CORS，參考[Solr, Jetty and CORS](https://chris.eldredge.io/blog/2015/04/02/solr-jetty-cors/)，將 `server/etc/webdefault.xml` 裡面，尾標記`</web-app>`的前面增加
```
  <filter>
    <filter-name>cross-origin</filter-name>
    <filter-class>org.eclipse.jetty.servlets.CrossOriginFilter</filter-class>
    <init-param>
        <param-name>allowedOrigins</param-name>
        <param-value>*</param-value>
    </init-param>
    <init-param>
        <param-name>allowedMethods</param-name>
        <param-value>GET,POST,DELETE,PUT,HEAD,OPTIONS</param-value>
    </init-param>
    <init-param>
        <param-name>allowedHeaders</param-name>
        <param-value>origin, content-type, cache-control, accept, options, authorization, x-requested-with</param-value>
    </init-param>
    <init-param>
        <param-name>supportsCredentials</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
      <param-name>chainPreflight</param-name>
      <param-value>false</param-value>
    </init-param>
  </filter>

  <filter-mapping>
    <filter-name>cross-origin</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
```
### 十一、 Vue 專案
用 Vue 搭配 Solr 可作出好用的查詢應用程式。

* simple-vue 專案用單純的 Vue 寫介面，以 Solr 當後臺，可以用 Chrome/Edge 進行查詢。
因為裡面用到 axios 套件，它利用 Promise 而IE 11 並不支援 Promise，所以無法使用 IE 11 進行查詢。
* yhvue 專案用Vue搭配 Webpack, Babel 寫介面，支援 Chrome/Edge/IE11/...。yhvue用到許多TCP阜，
用9124提供介面、9001提供檔案、8983,7574,9983提供solr支援。

### 雜項

```
bin\solr create -help
bin\solr delete -help
bin\solr status
http://192.168.182.80:8983/solr/admin/collections?action=list
http://192.168.182.80:8983/solr/
http://192.168.182.80:8983/solr/allsortofocuments/browse
```


### 2015000042.pdf
2015000042.pdf 需要用FontPack1900820071_XtdAlf_Lang_DC.msi安裝字形才能閱覽。
