---
typora-copy-images-to: ../pictures
typora-root-url: ../pictures
---

# 功能总览

## 联机功能

| **序号** | **业务功能**                       | **序号** | **业务功能**                   |
| -------- | ---------------------------------- | -------- | ------------------------------ |
| 1        | 产品工厂                           | 17       | 利率计划                       |
| 2        | 业务参数模型                       | 18       | 客户自定义限额管理             |
| 3        | 卡账关系管理                       | 19       | 属性设置/联机属性刷新          |
| 4        | 开户                               | 20       | 账户形态管理                   |
| 5        | 存入/支取/结售汇                   | 21       | 账户协议透支                   |
| 6        | 一对一转账/多借多贷/多个一对一转账 | 22       | 约定转账/约定转存定期          |
| 7        | 销户                               | 23       | 关联保护/保护次序调整          |
| 8        | 定期存入/定期支取                  | 24       | 存折登折相关                   |
| 9        | 冻结/续冻/解冻/扣划                | 25       | 电子账户绑卡/账户手机号验证    |
| 10       | 待支取利息提取                     | 26       | 产品利息试算/产品利率试算      |
| 11       | 存放同业                           | 27       | 活期销户试算/定期支取试算      |
| 12       | 倒起息/利息手工调整                | 28       | 目标存款/智能存款/到期计划支取 |
| 13       | 定期到期后手工转存                 | 29       | 支票相关                       |
| 14       | 账户维护/续存设置/转存指令         | 30       | 集团账单管理                   |
| 15       | 联名账户                           | 31       | 交易对账                       |
| 16       | 利率维护                           | 32       | 各类信息查询                   |

## 批量功能

| **序号** | **日终批量**                | **序号** | **日终批量**       |
| -------- | --------------------------- | -------- | ------------------ |
| 1        | 到期自动解冻                | 16       | 定期按计划支取     |
| 2        | 存款计息/透支计息           | 17       | 定期按计划存入     |
| 3        | 存款利率重定价              | 18       | 久悬户自动销户     |
| 4        | 透支重定价                  | 19       | 存款报表           |
| 5        | 存款结息                    | 20       | 预付卡到期自动销户 |
| 6        | 透支结息                    | 21       | 应计利息总分核对   |
| 7        | 批量收费                    |          |                    |
| 8        | 存款计提数据汇总            |          | **定时任务**       |
| 9        | 存款上日余额数据汇总        | 1        | 约定转账           |
| 10       | 活期转智能存款              | 2        | 约定开定期         |
| 11       | 定期到期续存/定期到期转逾期 | 3        | 集团账单生成       |
| 12       | 正常户转不动户              | 4        | 文件一对一转账     |
| 13       | 不动户转久悬户              | 5        | 文件冻结解冻       |
| 14       | 久悬户自动销户              |          |                    |
| 15       | 双零余额账户自动销户        |          |                    |

# 参数

## 1. 产品基础属性

### 表

| 表名                 | 中文名                               |
| -------------------- | ------------------------------------ |
| dpf_base             | 产品基础属性                         |
| dpf_open             | 产品开户控制（开户时用，不落地）     |
| dpf_save             | 产品存入控制                         |
| dpf_draw             | 产品支取控制                         |
| dpf_interest         | 产品计息定义                         |
| dpf_pay_inst_plan    | 产品付息计划（不规则周期付息）       |
| dpf_td_draw_interest | 定期支取计息定义(不落地到账户层)     |
| dpf_form_move        | 活期产品形态转移定义(不落地到账户层) |
| dpf_batch_fee        | 产品批量收费定义                     |

### 维护接口

| flowtrans | desc             |
| --------- | ---------------- |
| 4900      | 负债产品参数查询 |
| 4950      | 负债产品参数维护 |
| 4901      | 负债产品模糊查询 |
| 4960      | 负债产品复制     |
| 4963      | 负债产品新增     |

## 2.业务参数模型

### 表

| 账户类型相关          |                        |
| --------------------- | ---------------------- |
| dpp_account_type      | 账户类型定义           |
| dpp_account_prod      | 账户类型关联产品控制   |
| dpp_account_voucher   | 账户类型关联凭证控制   |
| dpp_subacct_voucher   | 子账户类型关联凭证控制 |
| dpp_account_condition | 账户类型支取条件控制   |

| 冻结相关 |      |
| -------- | ---- |
| dpp_froze_type         | 冻结类型定义         |
| dpp_froze_mutex        | 冻结类型互斥         |
| dpp_froze_channel      | 冻结渠道控制         |
| dpp_froze_spec_channel | 冻结特定渠道控制     |

| 透支相关           |              |
| ------------------ | ------------ |
| dpp_overdraft_type | 透支类型定义 |

### 维护接口

| flowtrans        | desc         |
| ---------------- | ------------ |
| **账户类型相关** |              |
| 4952             | 账户类型维护 |
| 4961             | 账户类型新增 |
| **冻结相关**     |              |
| 4953             | 冻结类型维护 |
| 4962             | 冻结类型新增 |

## 3.技术参数

### 表

| 表名                  |                |
| --------------------- | -------------- |
| dpp_condition_feature | 支取条件定义   |
| dpp_froze_trxn        | 冻结交易码控制 |

# 业务

## 1.开户

**结构模型**：产品工厂 + 账户类型相关 --> 子户/账户/卡

<img src="/image-20200427161153031.png" alt="image-20200427161153031" style="zoom:50%;" />

**接口**

| flowtrans | desc         |
| --------- | ------------ |
| 4000      | 活期开户     |
| 4001      | 定期开户     |
| 4002      | 同业活期开户 |
| 4003      | 同业定期开户 |
| 4004      | 新开账户     |

### dp4000 活期开户

#### 新开账户

1. 刷新卡属性、客户属性

   DpBuffer.[refreshAttrValue](#refreshAttrValue)

  2. 检查开户合法性

   DpOpenAccountCheck.[checkMainMethod](#checkMainMethod)

3. 生成客户账号 genAccountNo（这个方法备注清晰）

4. 登记客户账户信息 registerAccountInfo，包括：

   登记 dpa_account

   登记 apb_account_route 账户路由表

   登记 apl_reversal_event 冲正事件

5. 登记卡账关系对照及相应登记簿 registerCardInfo

   登记卡信息		DpCardAccountRelate.[registerCardInfo](#registerCardInfo)

   登记卡账关系	DpCardAccountRelate.[registerCardRelate](#registerCardRelate)

   登记卡账变更簿DpCardAccountRelate.[registerCardChangeBook](#registerCardChangeBook)

#### 新开子账户

#### 非零金额开户

## 2.存入/支取/结售汇

**接口**

| flowtrans | desc             |
| --------- | ---------------- |
| 4020      | 一对一转账       |
| 4021      | 多对多转账       |
| 4022      | 多个一对一转账   |
| 4023      | 外币现金兑换     |
| 4040      | 定期存入         |
| 4041      | 定期支取         |
| 4042      | 同业定期支取     |
| 4052      | 定期到期手工转存 |

## 3.销户

**接口**

| flowtrans | desc     |
| --------- | -------- |
| 4011      | 活期销户 |
| ....      |          |

## 4.冻结解冻

> 法院等权力机关发起的称作**“冻结”**，银行发起或客户自己要求发起的称作**“止付”**。

**表**

| 表名              | desc         |
| ----------------- | ------------ |
| dpp_froze_type    | 冻结类型定义 |
| dpp_froze_mutex   | 冻结类型互斥 |
| dpp_froze_channel | 冻结渠道控制 |
|                   |              |

**接口**

| flowtrans | desc               |
| --------- | ------------------ |
| 4030      | 冻结止付           |
| 4031      | 续冻               |
| 4032      | 解冻解止           |
| 4033      | 法院扣划           |
| 4495      | 冻结分类码列表查询 |
| 4496      | 冻结分类码信息查询 |

## 5.利息

**接口**

| flowtrans | desc             |
| --------- | ---------------- |
| 4050      | 待支取利息支取   |
| 4051      | 账户利息调整     |
| 4449      | 账户利率计划查询 |
| 4450      | 账户利率查询     |
| 4451      | 账户应计利息查询 |
| 4452      | 产品利息试算     |
| 4453      | 活期销户利息试算 |
| 4454      | 定期支取利息试算 |
| 4455      | 账户付息信息查询 |

## 6.账户维护

**接口**

| flowtran | desc             |
| -------- | ---------------- |
| 4200     | 账户信息维护     |
| 4220     | 账户利率维护     |
| 4221     | 账户利率计划维护 |

## 7.账户相关查询

**接口**

| flowtran | desc             |
| -------- | ---------------- |
| 4400     | 账户详情查询     |
| 4401     | 账户列表查询     |
| 4402     | 子账户信息查询   |
| 4403     | 主账户信息查询   |
| 4405     | 存款子户列表查询 |
| 4410     | 存款账单查询     |
| 4420     | 冻结查询         |
| 4421     | 冻结明细查询     |

## 8.其他查询

**接口**

| flowtran | desc             |
| -------- | ---------------- |
| 4201     | 法院查询账户信息 |





# dp01

> 计息结息

## 1 数据源

dpa_sub_account中，**sub_acct_status='1'**  and **next_inst_date <= trxn_date**(下次计息日期在当前日期之前,包括当前日期)

## 2 前准备

1. 查询子账户信息（带锁）
2. 将交易机构设置为子账户的账务机构
3. 获取银行当天挂牌利率变动范围（获取数据源时，已经获取过，存放在属性去，所以可以直接从属性区复制过来）
4. 在公共运行区cust_field里面增加计息账号(Interest account)字段（暂时不知道之后做什么用？？？）

## 3 透支账户计息

> 透支账户肯定是活期，定期不存在透支。

​	前提：账户允许透支，subAcct.getOverdraft_allow_ind() == E_YESORNO.YES

​	略。。。。之后再补

## 4 存款利息计息

### 登记账户历史余额拉链表

> 计不计息都登记账户历史余额拉链表

1. 获取 账户上日余额  && 账户上日浮动额

   如果Bal_update_date>=trxn_date,说明账户余额是今日刚更新的，则账户上日余额=Prev_date_bal，否则就取当天余额Acct_bal作为上日余额；（该情况一般只出现在日切ap05后，账户进行金融交易了。因为dp01是日切后，所以此时trxn_date已经是新的一天）

   账户上日浮动额同理；

2. 查询账户历史余额登记簿；**要用上日交易日期去查**，因为已经日切了

   > dpb_balance_hist这张表的数据是按日期连续的，同sub_acct_no的下一条记录start_date是上一条记录的end_date。

   ```sql
   select * from dpb_balance_hist where sub_acct_no='...' and start_date<= 'last_date' and  start_date <=  'end_date';
   ```

3. 登记dpb_balance_hist表

   比较 上面1和2获取到余额/浮动额是否相等，如果相等，则不更新dpb_balance_hist。（特殊：如果是每月1号则需更新，方便之后数据清理）

   **场景一**： lastDate > 起息日期：开户时有倒起息，开户日到计提时没有再次倒起息。

   需要update：end_date = last_date-1;

   再insert新记录；
   
   **场景二**： 开户时无倒起息，开户日到计提时没有再次倒起息
   
   **场景三**：开户时有倒起息，本次计提前有倒起息

### 获取计提利息索引类型

1. due_date != null && trxn_date > due_date  ==>  E_INSTKEYTYPE.MATURE 到期利息（一般只有定期才有）
2. Remnant_day_start_date != null && trxn_date > Remnant_day_start_date==>  E_INSTKEYTYPE.REMNANT 零头天数利息（一般只有定期才有）
3. 其余都为正常利息（活期、定活两遍、通知存款...）

### 读取账户计息信息

> dpa_interest

### 账户不计息处理

> 账户不计息（inst_ind），但是有计息定义信息dpa_interest，则滚积数：
>

1. 获取"上日余额"(和上面一样)

2. 比较"上日余额" 和 "最小计息金额(min_inst_bal)"，如果小于，直接将"上日余额=0"

3. 计算计息天数：trxn_date - next_inst_date + 1。
   比如next_inst_date=20200120，trxn_date=20200120,则需要计息的天数包括：**19号**,因为dp01是830(日切后)，所以trxn_date其实已经是新的一天开始，所以20号当天不计息，计的是19号。

4. 计算积数相关（积数计息法）：

   1. 新增积数= 上日余额  * 计息天数
   2. 应计积数accrual_sum_bal = 原应计积数 + 新增积数
   3. 本期应计积数 cur_term_inst_sum_bal = 原本期应计积数 + 新增积数

5. 清零积数，避免爆表

   Pay_inst_method() != E_PAYINSTWAY.NO_CYCLE   &&   Next_pay_inst_date  == trxnDate
   付息方式 != 到期付息（一般只有"定期账户" 或者 "活期账户到期利息" 的付息方式为到期付息） 
   && 下个付息日 = trxn_date（活期的付息周期一般为一个月付一次，也就是一个月清理一次积数），因为这里是不计息账户，所以直接清理。

   设置下一个付息日

6. 每年12月31日晚日终计提时转移本年积数

7. 更新计息定义表

8. 更新子账户表（上次计息日、下次计息日）

### 获取利息税率（暂时略）

### 登记账户历史税率表

> 登记账户历史税率表: 开户日晚上计提、税率有变动

### 利息计提: 包含利率靠挡

> **这里算真正进行利息计提操作**
>
> 这的利率靠档，在其他版本中可能放在最后利率重定价中。

#### 计算利息

> 遇到卡片账更新卡片数据

##### 获取账户上日余额

作为计息余额

##### 取税率信息(暂略)

##### 计提前先尝试利率靠挡

> 利率重定价方式 = E_RATERESETWAY.NEAR 靠档日重定价

DpInterestRateAdjust.doInrtAnearGrade

##### 获取账户利率

> List<dpa_interest_rate>

##### 1-卡片计息

- 获取卡片计息信息

  > List<dpa_fiche_interest>

- 循环处理卡片计息信息

  - 卡片历史余额登记-dpb_fiche_balance_hist

    和登记dpb_balance_hist的方式一样。

  - 卡片计提利息计算

    - 获取卡片上日余额：dpa_fiche_interest：bal_update_date
    - 获取卡片利率信息：List<dpa_fiche_interest_rate>
    - 1-分层计息
    - 2-单层计息：即([3-单层计息](#3-单层计息))
    - 转移到卡片利息明细：把List_inst_detail的信息转移到List_fiche_detail，并清除List_inst_detail的信息。
    - 输出计算结果

  - 登记卡片利息明细:dps_fiche_accrued

  - 更新卡片计息定义表

  - 卡片计息信息更新

- 利息计提结果输出


##### 2-分层计息

##### 3-单层计息

```shell
1.	next_inst_date:下次计息日。
	e.g. next_inst_date = 20201010 表示20201010之前的利息都计提了，20201010开始(包括20201010)都还没计提.则跑批到20201010时该账户就会计息
	所以：
2.	起息日:默认就是下次计息日的前一天 startInstDate = next_inst_date - 1 = 20201009
3.	计提天数 = trxn_date - next_inst_date + 1 = 20201010 - 20201010 + 1 = 1
```

- 初始起息日头天不计息，则减少一天计息

  > 这个就是首日计息标志First_date_inst_ind = NO， 并且起息日 = 初始起息日，则减去第一天。一般就新开的子户可能出现

- 按储蓄天数计息

- 按实际天数计息

  > 活期利率小，如果金额小则容易累计误差，使用**积数计息法**可以有效减小这种情况。
  >
  > **积数计息法：**按实际天数每日累计账户余额，以累计积数乘以日利率计算利息的方法。
  >
  > ​	利息＝累计计息积数×日利率
  >
  > ​	累计计息积数＝每日余额合计数
  >
  > ​	日利率 = 年利率/年天数
  >
  > - 本期总积数 = 计息余额 * 本次计息天数 + 原本期总积数	（这个期指的是付息周期内，也即付息周期内累计积数）
  - 获取年计息天数：app_currency：accrual_base_day
  - 本期总利息 = 总积数 * 日利率 = 总积数 * 年利率 / 年计息天数
  - 本期总税金： 利息税 = 利息 \* 税率 ，增值税 = 利息 \* 增值税率
  - 增量(也就是这次计息的增量)：
    - 本次计提利息 = 本期应计总利息 - 上次本期应计利息(dpa_interest：cur_term_inst)
    - 本次计提积数 = 本期应计总积数 - 上次本期应计积数(dpa_interest：cur_term_inst_sum_bal)
- 利息计提结果输出

#### 登记计提利息明细记录

> dps_accrued_interest

### 更新账户计息定义表

> dpa_interest

### 更新子账户信息

> dpa_sub_account

### 登记每日计提利息登记簿

> dpb_interest_hist

## 5 结息

- 获取计提利息索引类型:getCainInstKey
- 读取账户计息信息:dpa_interest
- 付息
  - 周期付息，且到期日不是周期结息日（活期？部分定期？）
  - 定期到期付息: 全部记到待支付利息，如果设有到期指令则到期指令步骤再处理待支付
- 不规则付息变更付息周期
- 更新计息定义表
- 周期结息日为今天的，重置净存入余额字段

## 6 利率重定价



# dp03

> 久悬收费

### 数据源

dpa_sub_account's sub_acct_status=Normal and  exist dpf_batch_fee（产品批量收费）

### 主体步骤

1. 根据prod_id,获取有效期内的List<dpf_batch_fee>，并根据优先级排序

2. 遍历List<dpf_batch_fee>

   1. 查询dpb_batch_fee(子账户批量收费登记)，

      如果为null，则登记一条子账户批量收费记录（dpb_batch_fee的多数信息继承于dpf_batch_fee），再获取出来；

   2. 互斥费用代码检查，收了这笔费用，则互斥的就不收取了。

   3. 计算下次收费日期

   4. 平均余额计算

   5. 添加输入数据集

      每次都添加,因为重置交易流水会清空所有缓冲区数据,如果不加载会导致规则匹配失效

   6. 收费条件规则校验

      部分dpf_batch_fee有费用准入条件，需要进行规则匹配；

   7. 调用公共收费

      1. calcManualChrg 手工收费试算
      2. prcManualChrgAccounting 手工收费处理

   8. 重置交易流水

   9. 更新上次下次收费日期

      无论收费有没有成功都必须更新下次收费日期，因为没成功就会登记欠费信息，如果失败不更新下次收费日期就会每天去跑收费，导致每天欠一次或多次费，而不是想要的一个月欠一次

# dp11

> 定期到期转存(续存)

## 数据源

​	dpa_sub_account

## 主体步骤

### 1. 获取续存金额

#### **1.1 本金转存**

续存金额 = 账户余额

利息转入收息账户

#### 1.2 本息转存

续存金额 = 账户余额 + 待支付利息- 利息税（待扣增值税+待扣利息税）

#### 1.3 减少本金转存

续存金额 = 账户余额 + 待支付利息- 利息税（待扣增值税+待扣利息税）- renew_save_amt（**减去的金额**）

#### 1.4 添加金额转存

续存金额 = 账户余额 + 待支付利息- 利息税（待扣增值税+待扣利息税）+ renew_save_amt（**增加的金额**）

#### 1.5 **转入其他账号**

- 批量时，续存不检查冻结

  续存金额 = 账户余额 + 待支付利息- 利息税（待扣增值税+待扣利息税）

- 联机

  暂不讨论

### 2. 检查续存合法性

> 简单来说，类似做开户时的检查，因为续存等价于再次开户。包括：存款产品检查、账户与产品的适配性、开户控制

### 3. 转账处理

> 本金转存，利息入收息账户，本金不动；
> 本息转存，利息入自身账户，本金不动；
> 减少本金转存，利息入自身账户，需减去本金入指定账户；
> 添加本金转存，利息入自身账户，指定账户转钱到当前账户；
>
> 转入其他账户，利息和本金转入其他账户，销户；

#### 3.1 本金转存

> 只需处理利息，因为本金还是保留在原先账户上。只需将**待支取利息转入收息账户**

- **待支付利息记账**

  - 应付利息登记会计事件tas_accounting_event

    ```sql
    select * from tas_accounting_event where 
    accounting_alias = subAcct.getAccounting_alias() AND -- 应付利息账户别名
    accounting_subject='1'(E_ACCOUNTINGSUBJECT.DEPOSIT) AND -- 会计主体
    debit_credit='D' AND -- 借贷方向(借 应付利息)
    bal_attributes='DP02'; -- 余额属性，待支付利息
     -- 借贷方向说明(银行角度)：
     对于“银行”来说，应付利息是“负债”，即：应付利息进了收息账户
     借 应付利息
     	贷 收息账户存款
    ```

  - 利息税登记会计事件

    ```sql
    select * from tas_accounting_event where 
    accounting_alias = subAcct.getAccounting_alias() AND -- 应收税款账户别名
    accounting_subject='1'(E_ACCOUNTINGSUBJECT.DEPOSIT) AND -- 会计主体
    debit_credit='C' AND -- 借贷方向(贷 应收税款)
    bal_attributes='DP03'; -- 余额属性，利息税
     -- 借贷方向说明(银行角度)：
     对于“银行”来说，应收税款是“资产”，即：从账户存款中扣掉应收税款
     借 客户存款
     	贷 应收税款
    ```

- **利息入账**

  > 利息转入收息账户

  - 入利息

    1. 更新收息账户余额

    2. 登记账单表

    3. 登记会计事件

       ```sql
       select * from tas_accounting_event where 
       accounting_alias = subAcct.getAccounting_alias() AND -- 入息账户别名
       accounting_subject='1'(E_ACCOUNTINGSUBJECT.DEPOSIT) AND -- 会计主体
       debit_credit='C' AND -- 借贷方向(贷 收息账户存款。对应上面的应付利息)
       bal_attributes='DP01'; -- 余额属性，本金
       ```

  - 扣利息税

    1. 更新收息账户余额

    2. 登记账单表

    3. 登记会计事件

       ```sql
       select * from tas_accounting_event where 
       accounting_alias = subAcct.getAccounting_alias() AND -- 入息账户别名
       accounting_subject='1'(E_ACCOUNTINGSUBJECT.DEPOSIT) AND -- 会计主体
       debit_credit='D' AND -- 借贷方向(借 客户存款。对应上面的应收税款)
       bal_attributes='DP01'; -- 余额属性，本金
       ```

#### 3.2 本息转存

> 本息转存，与本金转存极类似。本金还是不动，只是利息是转入自身账户

- **待支付利息记账**

  同“本金转存”

- **利息入账**

  同”本金转存“，区别在于入自身账户而已

#### 3.3 减少本金转存

> 利息入自身账户（同上，略），需减去的本金转出

- 利息记账，利息入账（同上，略）
- （先借后贷）当前账户定期金额取出，转入prin_trsf_acct（本金转入账户，本金转出来到的账户）

#### 3.4 添加金额转存

> 利息入自身账户（同上，略），添加本金转入

- 利息记账，利息入账（同上，略）
- （先借后贷）prin_trsf_acct取出，转入当前账户（本金转入账户，转出钱到本金的账户）

#### 3.5 转入其他账号

- 利息入收息账户
- 本金转入其他账户
- 销户

### 4. 重置账户信息

### 5. 登记转存信息



# dp4030冻结止付

## 1. 检查

- 由Froze_kind_code，查dpp_froze_type是否存在

- 检验冻结原因合法性(下拉字典) ：app_drop_list - FROZE_REASON

- 检查冻结金额的合法性：froze_type为金额冻结时检查

- 检查冻结到期日期的合法性：

  - 获取实际冻结到期日：由两个输入参数决定：froze_term冻结时限、froze_due_date冻结到期日
    如果两个都有值，但不相等时则报错。否则就取其中一个，都没有值则为null。
  - 检查最大冻结到期日：实际冻结到期日不得大于该值。dpp_froze_type-Max_froze_term

- 检查冻结对象的合法性：

  - 冻结对象类型 == SUBACCT

  - 冻结对象类型 == ACCT

  - 冻结对象类型 == CARD

  - 冻结对象类型 == CUST

    四种检查对象的检查内容大致相同，定位，检查状态，同业、一些业务限制

- 冻结互斥检查：dpp_froze_mutex

- 交易控制检查: 包括业务规则、属性检查 app_trxn_control

## 2. 主业务

### 收费试算+扣费

### 登记dpb_froze

根据4种froze_object_type,填入对应froze_object。**其中froze_object_type==CARD时，为了避免换卡带来的影响，卡froze_object填的是账号**

### 登记dpb_froze_detail

### 限额处理

### ==更新账户信息==

1. 查询出当前冻结对象在dpb_froze中存在哪些冻结类型(因为前面插入了dpb_froze数据，所以这里查询出来的数据包含本次所有冻结记录)：**不进不出>只进不出>金额冻结**
2. 根据冻结类型，选择限制类型
   - 金额冻结不改变账户限制状态 return E_ACCTLIMITSTATUS.NONE;
   - 只进不出 return E_ACCTLIMITSTATUS.IN;
   - 不进不出 return E_ACCTLIMITSTATUS.SEAL;
3. 更新账户信息
   - 冻结对象类型 == ACCT------>更新dpa_account：Acct_limit_status
   - 冻结对象类型 == SUBACCT------>更新Dpa_sub_account：Sub_acct_limit_status
   - 冻结对象类型 == CARD------>更新Dpa_card：Card_limit_status
   - 冻结对象类型 == CUST------>更新cfb_person_base：Cust_limit_status

----分割线---

# dp4011活期销户

1. 活期结清
   1. 有冻结先做解冻处理
   2. 检查是否存在未清算的预授权交易
   3. 存款利息结清
   4. 透支利息结清
2. 自动收费
3. 活期支取（支取账户余额）
4. 检查存入金额
5. 贷方资金记账分析
6. 活期存入
7. 销子账户(含检查)

# 公共代码

## DpBuffer

### getCustMapInfo

> 获取客户信息，转为Map

### addDataToCustBuffer

1. 读取数据缓冲区的客户信息
2. 获取客户信息（Map形式）[getCustMapInfo](#getCustMapInfo)
3. 从客户信息中取出属性值
4. ApAttribute.[getNewestAttrValue](#ApAttribute)获取cust层属性值

### refreshAttrValue

> 更新各数据域最新属性值，有不同重载形式

1. 获取各层级最新属性值[getNewestAttrValue](#getNewestAttrValue)
2. 更新各层级的属性信息

### getNewestAttrValue

> 获取各数据域最新属性值

1、获取sub_acct层属性值
ApAttribute.[getNewestAttrValue](#ApAttribute)

2、获取acct层属性值
ApAttribute.[getNewestAttrValue](#ApAttribute)

3.1、加载cust数据集

DpBuffer.[addDataToCustBuffer](#addDataToCustBuffer)

3.2、获取cust属性值

> 获取cust层的属性值的代码有点冗余，addDataToCustBuffer取得客户信息后，把属性值放到缓存域中，之后又从缓冲域中取出该属性值。其实可以直接返回改属性值。

4、获取card属性值

> 需先把卡信息存入到卡缓存中

ApAttribute.[getNewestAttrValue](#ApAttribute)



​     

​     

​     

## DpCardAccountRelate

> **卡账关系**处理类，包含CRUD

### registerCardInfo

### registerCardRelate

### registerCardChangeBook

## DpPublic

> 负债业务常用方法

### locateSingleAccount

> 账户定位

### getBalance(...)

> 获取子账户的余额信息

全额冻结：包括(只进不出、不进不出) 全额冻结更像是对账户本身的一种控制，而不是对金额冻结。 froze_type != 'A' and froze_status != '1'。

当有全额冻结时，

- **acct_bal**：账户余额

  > 1. 直接取dpa_sub_account的**acct_bal**（包含冻结金额）；
  >
  > 2. 特殊场景(不常见)：存入金额时同时冻结，则：**账户余额需要包括本次冻结前存入的金额:，因为在一个事务中调用冻结检查时此时存入动作可能还没发生**。即：
  >    **acct_bal = acct_bal + froze_before_save_amt**

- **hold_amt**：止付金额

  > froze_source= E 外部来源，即：冻结金额

- **froze_amt**：冻结金额，只包括金额冻结的值

  > froze_source= I 内部来源，即：止付金额

- **fact_froze_amt**：实际冻结金额

  > 冻结金额+止付金额

- **self_usable_bal**：自身可用余额，不包含资金池额度

  > - **自身可用余额 = 账户余额 - 实际冻结余额**
  >   self_usable_bal = acct_bal - fact_froze_bal
  >
  > - 支取类型不是强行扣划和销户时，可用余额还应减去最小留存金额，其中实际冻结金额可以抵扣最小保留金额：
  >
  >   **自身可用余额 = 账户余额 -  实际冻结余额 与 最小留存金额中大的一个**
  >
  >   self_usable_bal = acct_bal - max( fact_froze_bal, min_remain_bal)
  >
  >   **self_usable_bal = acct_bal - (( fact_froze_bal > min_remain_bal ) ? fact_froze_bal :min_remain_bal)**

- **usable_bal**：可用余额，包含资金池额度

  > - **可用余额 = 自身可用余额 + 资金池**

>资金池 与协议相关，包括：透支协议额度 + 保护协议额度，保护协议一般是同客户下不同账户，就好比A卡没钱了可以在B卡中借过来。

- **min_remain_bal**：最小留存金额

  > 直接取dpa_sub_account的**min_remain_bal**，若null则0

- **whole_frozen_ind**：全额冻结标志

- **whole_hold_ind**：全额止付标志


```java
if ( froze_type == 金额 ){
    
}
else 全额冻结 {
    if 外部 then 全额冻结
    if 内部 then 全额止付
}
```



## ApBusinessParm

> app_business_parameter(业务杂项参数表)的**查询类**

## ApBusinessParmMnt

> app_business_parameter(业务杂项参数表)的**维护类**

## DpOpenAccountCheck

### checkMainMethod

> 存款新开账户检查主调方法

1. 默认值
   1. 联名人标志默认为“否”
   2. 自选号码标志默认为“不选号”
2. 检查输入值
   1. 联名账户标志为YES时，检查客户信息数量 : 1 <联名账户数量< ApBusinessParm.getIntValue("DP_MAX_JOINT_ACCT")
3. 加载输入数据集 - INPUT
4. 加载参数数据区 - PARM
5. 客户信息检查, 加载客户数据集 - CUSTOMER
   1. dpp_account_type中的cust_type与查询出的客户信息要匹配
   2. cust_status检查
6. 如果存在卡信息,加载卡数据区 - CARD
7. 账户类型的定义做相关检查：对**dpp_account_type**中的控制进行校验
   1. 客户唯一控制标识**Sigl_cust_ctrl_ind**：非联名户的情况，一个客户下同acct_type只能有一个状态正常的dpa_account







# 草稿：

## DpAccounting

> 负债记账及账单登记方法

### online联机记账处理

余额更新