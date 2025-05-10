---
title: "Sentinel-1 数据拼接与裁剪（GMTSAR预处理）"
date: 2025-05-08 20:00:00 +0800
categories: [InSAR, 数据预处理]
tags: [Sentinel-1, GMTSAR, 数据预处理, 拼接, 裁剪]
pin: false
toc: true
comments: true
---

> 🚀📘 本文为 InSAR 学习笔记第一篇，主要记录 Sentinel-1 SLC 数据在 GMTSAR 中进行拼接与裁剪的基本操作，适用于后续 InSAR 干涉处理的准备阶段。

---

## 1. 为什么需要拼接与裁剪 Sentinel-1 数据？

Sentinel-1 SLC 数据通常以单个zip形式提供，每景覆盖区域约为250km * 180km。为了满足对一个广域研究区的处理需求，我们通常进行拼接。同时，为了提高处理效率并聚焦较小兴趣区域（AOI），我们也会对影像进行裁剪。

---

## 2. 所需工具与数据准备

- 🧩 软件环境：
  - [GMTSAR 软件](https://github.com/gmtsar/gmtsar)
  - Ubuntu22.04 环境

- 📦 数据裁剪：
  - 至少单个Frame的 Sentinel-1 SLC 产品（解压后为`.SAFE` 格式）
- 📦 数据拼接：
  - 至少两个相邻Frame的 Sentinel-1 SLC 产品（解压后为`.SAFE` 格式）

📷 示例：SLC 数据目录结构


📁 Sentinel_Path113Frame116/
`S1A_IW_SLC__1SDV_20230815T102947_20230815T103013_049885_060006_E81A.SAFE`
`S1A_IW_SLC__1SDV_20230722T102945_20230722T103012_049535_05F4D0_2890.SAFE`
`S1A_IW_SLC__1SDV_20230710T102945_20230710T103012_049360_05EF7C_DDA9.SAFE`

📁 Sentinel_Path113Frame121/
`S1A_IW_SLC__1SDV_20230815T103011_20230815T103038_049885_060006_EFC7.SAFE`
`S1A_IW_SLC__1SDV_20230722T103010_20230722T103033_049535_05F4D0_EFB7.SAFE`
`S1A_IW_SLC__1SDV_20230710T103010_20230710T103032_049360_05EF7C_AC3A.SAFE`

## 3. 创建list文件
📄 每个Frame的数据，需要制作为一个文件列表，前面需要加绝对路径。
- 📁 目录 Sentinel_Path113Frame116/
```bash
ls -d $PWD/*.SAFE > SAFE1.list
```
- 📁 目录 Sentinel_Path113Frame121/
```bash
ls -d $PWD/*.SAFE > SAFE2.list
```
如果是两个Frame，需要将列表合并为一个文件
```bash
paste -d: SAFE1.list SAFE2.list > SAFE.list
```
## 4.设定裁剪范围
- ✅ 制作pins.ll
一般是两个点的坐标，卫星先扫描到的点放在前面（e.g. 升轨数据，纬度低的点放在第一行）

```bash
110.82  36.68
113.25  38.81  
```
![图片说明文字](/assets/img/picture/p1.png)

图中黄色三角形为两个点的坐标，红框的范围是预计裁剪的范围，注意裁剪范围是根据burst确定的。两点的坐标并不是裁剪的边界。

## 5.裁剪影像
在新目录（organized）使用脚本`create_tops_frame.csh`进行数据拼接裁剪

 用法：
 ```bash
 create_tops_frame.csh SAFE.list Sentinel-1/orbit/path
 ```
 ![图片说明文字](/assets/img/picture/p2.png)