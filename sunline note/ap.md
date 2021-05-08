---
typora-copy-images-to: ../pictures
typora-root-url: ../pictures
---

## ApSeq

> 流水号工具类

### genSeq

> String genSeq(String seqCode)，根据seqCode获取流水号.
>
> 当流水组建标志为Y时，调用此函数前需要调用addDataToBuffer方法，往runEnvs中设置app_sequence_builder对于的rule_buffer.

1.获取流水号定义==app_sequence== [getAppSequence](#getAppSequence)

2.1 组建标志==NO

​	则不使用app_sequence_builder组装



2.1 组建标志==YES

​	则使用app_sequence_builder组装：

1. 取 List<app_sequence_builder>；

2. 判断app_sequence_builder中的`seq_build_class`组建类型（A 序号识别段 B 序号 C 校验位）；

   - A-RECOGNITION 序号识别段：就会去数据集中取值，app_sequence_builder的`data_mart`定义数据集，`field_name`定义字段名,

     对从数据集获取到的值进行截取/补位。长了截取，短了补位。cut_length定义了长度，paddlong_mode补位方式，paddlong_value补位值

   - B-SEQUENCE 序号： 由于序号段需要根据最终的识别段生成，因此这里先标记序号段位置

   - C-CHECKBIT 校验位：// 由于校验位需要根据最终的识别段和序号段生成，因此这里先标记校验位位置

3. 产生序号

4. 产生校验位

最后组装顺序就是app_sequence_builder中的data_sort



### getAppSequence

> 获取流水号定义
> return ==app_sequence==；

先查==app_sequence_reference 流水引用定义==：该表定义了某些流水(e.g. AUDIT_SEQ/TRXN_SEQ...)的指定法人，若有则需用到该表的流水法人seq_org_id。
再查==app_sequence 流水号定义==返回。







## ApAttribute

### getNewestAttrValue

> 获取最新属性值

1. 获取新属性值[builderData](#builderData)
2. 排序，转String后返回

### builderData

> 组织属性数据（其实就是：现属性位没有值或值过期，设置为默认值，否则保留不变）

1. [getOwnerDueDate](#getOwnerDueDate)：获取该用户的app_attribute_due(属性位到期日登记表)

2. 获取app_attribute(属性位定义表 )

3. 判断属性是否有值，以及是否到期。代码如下：

   ```java
   // 获取现属性位长度
   int attrValueLen = CommUtil.isNotNull(oldValue) ? oldValue.length() : 0;
   
   // 遍历属性定义表数据(对以下代码的总结：现属性位没有值或值过期，设置为默认值，否则保留不变)
   for (app_attribute attrDef : attrDefList) {
   
       ApAttrListIn record = BizUtil.getInstance(ApAttrListIn.class);// 返回值
   
       record.setAttr_position(attrDef.getAttr_position());// record赋值属性位置
   
       // if 属性定义的位置<=属性当前的长度，也即该属性位有值
       if (attrDef.getAttr_position() <= attrValueLen) {
           // 则：record设置属性值为现属性位的值；
           record.setAttr_position_value(oldValue.substring(attrDef.getAttr_position().intValue() - 1, attrDef.getAttr_position().intValue()));
       }
       else {
           //否则：record设置属性值为默认值(属性定义表)
           record.setAttr_position_value(attrDef.getDefault_value());
       }
   
       // 在app_attribute_due List中查找属性位置对应记录
       int dataIndex = getIndexByAttrDate(attrList, attrDef.getAttr_position());
   
       if (dataIndex >= 0) {
   
           // 当前日期是空（无需舍弃）, 或是 当前日期 小于等于 attrList日期（未过期）
           if (CommUtil.isNull(curtDate) || CommUtil.compare(curtDate, attrList.get(dataIndex).getAttr_date()) <= 0) {
               // 未过期
               record.setAttr_date(attrList.get(dataIndex).getAttr_date());// 属性到期日期
           }
           else {
               // 已到期，值需要复原到默认值(属性定义表)
               record.setAttr_position_value(attrDef.getDefault_value());// 属性值
           }
       }
       ret.add(record);
   }
   ```

   @param：属性层级、属主(账号、卡号、客户号、子账号)、原有属性值

   @return 新属性值

### getOwnerDueDate

> 获取app_attribute_due(属性位到期日登记表)
>
> 该方法可直接优化为一条sql，类型转换显得多余。

## ApBuffer

### addData

> 往某数据集缓存中添加数据(可以追加，也可覆盖)

数据集：ApDropList.exists("DATA_MART", dataMart);

### getBuffer

> 从BizUtil.getTrxRunEnvs().getRule_buffer();如果是空，则初始化。

## ApRule

> 规则引擎工具类

### checkTrxnControl

> 交易控制检查

获取`app_trxn_control交易控制定义`表中的数据，该表以`交易事件`为驱动，匹配规则ID。

交易事件有：`SELECT * FROM app_drop_list WHERE drop_list_type='EVENT_ID_LIST';`

   