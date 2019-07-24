[TOC]

# 简介

- 该项目为Native App与H5交互即JSBridge的封装使用，本仓库为iOS开发者提供
- Web前端：[JS-bridge](https://github.com/konghouyin/JS-bridge)
- Android端：

# 目标
- 最终目标是将整个调用封装成一个WKWebView，iOS开发者只需要使用封装的WKWebView去加载H5就能实现所有功能

# 使用的第三方库

- Masonry【1.1.0】
- JSONModel【1.8.0】

# 已实现的功能

## 基础

### 系统

#### getSystemInfoSync()【获取系统信息】

## 界面

### 交互

#### showModal【显示模态对话框】

- 模态对话框使用自定义View实现，在BounceView阴影View上盖了一个ModalView
- ModalView中有两个样式：viewWithoutCancel以及viewWithCancel
- 没写高度自适应，modal的高度是固定的

