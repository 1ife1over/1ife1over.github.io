---
title: "🎨 一些简单的绘图脚本介绍"
date: 2025-05-12 10:00:00 +0800
categories: [InSAR, 绘图]
tags: [InSAR, 绘图]
pin: false
toc: true
comments: true

---


> 在科研和日常学习中，绘图是一项重要技能。为了更高效地完成可视化任务，我整理了自己常用的GMT绘图脚本，便于日后复用和更新。

GMT中文手册，需要经产翻阅，内容非常详细
[GMT中文手册](https://docs.gmt-china.org/)

> 首先是我通常使用的绘图配置参数文件`gmt.conf`，这个文件负责定义图片的默认参数。大家根据喜好自行选择是否使用。

   <a href="/code/gmt.conf" download>gmt.conf</a>

## 1. ✏️ 绘制时空基线图

- 我们在手动增删干涉对之后，还需要再绘制出对应时空基线图，可使用脚本：

    [plot_baseline.csh](/code/plot_baseline.csh)

    ```bash
    plot_baseline.csh intf.in baseline_table.dat
    ```
    
   ![图片说明文字](/assets/img/picture/baseline.png)

---

## 2. 🎨 绘制笛卡尔坐标系栅格数据（雷达坐标系）

- 快速预览绘制笛卡尔坐标系的栅格数据，可使用脚本：

    [plot_grd_JX.csh](/code/plot_grd_JX.csh)

    ```bash
    plot_grd_JX.csh grd_file limitL limitU cpt
    ```
    
   ![图片说明文字](/assets/img/picture/plot_phase.jpg)

---

## 3. 🎨 绘制地理坐标系栅格数据（WGS84）

- 快速预览绘制地理坐标系的栅格数据，可使用脚本：

    [plot_grd.csh](/code/plot_grd.csh)

    ```bash
    plot_grd.csh grd_file limitL limitU
    ```
    
   ![图片说明文字](/assets/img/picture/plot_vel.png)

---

## 4. 📈 绘制时间序列图

- 快速预览绘制时间序列，可使用脚本：

    [plot_timeseries.csh](/code/plot_timeseries.csh)

    ```bash
    plot_timeseries.csh disp_file
    ```
    
   ![图片说明文字](/assets/img/picture/plot_ts.png)


## 5. 🔄 数据格式的转化

- TIF栅格数据转GRD：

    ```bash
    gdal_translate -of GMT A.tif A.grd
    ```
    
- GRD栅格数据转TIF：

    ```bash
    gdal_translate -of Gtiff A.grd A.tifff
    ```
    
- shp要素数据转GMT：

    > 📢注意，在GMT6.1版本后，可直接绘制shp数据， 一个shapefile文件通常至少包含三个文件`.shp`、`.shx` 和 `.dbf `。如果觉得文件太多，也可转为`gmt`格式，仅需一个文件绘图。

   - GMT6.5版本 [参考网站](https://docs.gmt-china.org/latest/utilities/gdal/#ogr2ogr/)

        ```bash
        ogr2ogr -f "" A.shp
        ```


   - GMT6.0版本 [参考网站](https://docs.gmt-china.org/6.0/dataset/gadm/?highlight=ogr2ogr)    

        ```
        ogr2ogr -f OGR_GMT A.gmt A.shp
        ```
