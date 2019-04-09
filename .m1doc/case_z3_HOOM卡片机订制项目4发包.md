## 目标

收取客户10万定金，Apr 1 提供升级包出来。

## 真正原因 - True causes

机制流程问题 ＞ 技术问题

定制项目基本流程，以哪个产品为**基线**，描述出差异项是关键。

## 问题描述 - from R&D or Tester

1 4.1 第一版: 升级包发送给chenyl
  4.8 chenyl说自己没有时间，将验证工作移交给测试部，并补充邮件如下:
        a. 升级恢复出厂默认后，即是HOOM卡片机类型，不需要进行“产测工具”进行feature设置
        b. “产测工具”无crop框
        c. APP中无电子云台
      以上功能不满足，被打回

2 4.8 第二版: -DYouKeShu -DShuoShiJia 代码手手误导致出错
      int get_video_quality_channage()

3 4.8 第三版: 修改宏 -DYouKeShu -DShuoShiJia
      feature默认=1，音频参数是小魔方，而非HOOM

4 4.9 第四版:
      feature默认=4，音频参数HOOM

4 4.9 第五版:
      防止对码当次就通过APP切换ssid **所谓测试，即对input(核心事件)，检查是否得到预期的output**

## 现象分析 - log

事与愿违的典型，一心求快，却迟迟未能交付

## 原因分析 - 原因猜想，目标分解，process to true causes

项目经理(开发人员) + 测试 + 产品经理(PDM,开发代表)，相关人员对功能没有串讲，对验收标准达成统一，并不能形成合力。

1 基线版本有问题(对码当次通过APP切换ssid无效)
  在 feature=4 的HOOM为基线，而非 feature=1 为基线

2 沟通缺失
  a HOOM卡片机类型，不需要进行“产测工具”进行feature设置，
    产品经理声称与PM沟通，PM并未交代SWE
  b 产品经理邮件都不抄送

3 验收标准缺失
  用例应该由开发人员给出
  **不要暴露过多细节给测试人员**，feature=4或是其它值，这并不重要

## 解决方案 - 包括对未来的防御

制度: 做正确的事
流程: 正确地做事

1 Marketing 与客户确定需求
2 Marketing 与产品经理确定需求
3 产品经理与PM沟通需求，确定可行性
4 PM组织宣讲(core or extend, SWE, STE)
5 测试用例
6 验收
7 客户参与
8 开局

