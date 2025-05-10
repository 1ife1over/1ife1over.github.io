---
title: "InSAR 数据准备：Sentinel-1、Envisat、轨道、DEM下载"
date: 2025-05-08 20:05:00 +0800
categories: [InSAR, 数据准备]
tags: [Sentinel-1, Envisat, DEM, Orbit]
pin: false
toc: true
comments: true
---


在 InSAR 数据处理过程中，数据准备是基础而关键的一步。本篇记录如何获取并组织 Sentinel-1 和 Envisat 数据、轨道文件以及数字高程模型（DEM）数据。

## 1. Sentinel-1 数据下载与解压

- 🔧 Sentinel-1 数据可从 [ASF DAAC](https://search.asf.alaska.edu/) 获取，需要筛选 `SLC` 模式数据。

     下载数据压缩包`*.zip`
- 数据解压后，一般不保留vh极化数据。

    单个文件解压，可选择脚本`unzip_sentinel-1.csh`
    ```bash
    unzip_sentinel-1.csh Sentinel-1/zipfile/path
    ```
    批量数据并行解压，可选择脚本`unzip_s1_parallel.csh`
    ```bash
    unzip_s1_parallel.csh Sentinel-1/zipfile/path  ncores
    ```
   - 文件命名规则如下
   ![图片说明文字](/assets/img/picture/p5.png)


- 使用以下命令将工作目录中所有 `.SAFE` 文件生成 `safe.list`（**绝对路径**）：

    ```bash
    ls -d $PWD/*.SAFE > SAFE.list
    ```

## 2. Envisat ASAR 数据下载

- 🔧 Envisat ASAR 数据可从 [esar-ds.eo.esa.int](https://esar-ds.eo.esa.int/socat/ASA_IMS_1P) 获取

![图片说明文字](/assets/img/picture/p3.png)

    文件示例
    `ASA_IMS_1PNESA20061231_230839_000000182052_00348_25276_0000.N1`

## 3. Sentinel_1 轨道数据下载

- 🚀 建议使用脚本下载轨道数据`*EOF`文件。在此，我建议将所有的EOF放置在一个文件夹，避免重复下载，需要使用时仅需链接即可。
    
- 📦 使用脚本`Sentinel_1_orb_download.csh`，该脚本能够将已下载过的链接过来，没下载的下载，并把下载的存入总轨道文件夹中
    ```bash
    Sentinel_1_orb_download.csh filelist
    ```

## 4. DEM 数据
- 🚀 直接使用脚本即可快速下载`dem.grd`
    
    命令行输入：
    ```bash
    make_dem.csh W E S N [mode]
    ```


