---
title: "时间序列季节性形变拟合（基于Matlab）"
date: 2025-06-03 09:14:00 +0800
categories: [InSAR, 时间序列分析]
tags: [季节性形变, 模型拟合, 数据处理, MATLAB]
pin: false
toc: true
comments: true
math: true
---

>  📈 本文记录了一种基于InSAR时间序列数据的地表形变季节性拟合方法，包括线性速率、年周期振幅/相位、半年周期振幅/相位的提取。附完整 MATLAB 脚本以便复用。

![模型拟合](/assets/img/picture/modelfit1.png)

## 📌 1. 背景简介

在InSAR时间序列分析中，地表形变信号通常不仅包含长期趋势（如地面沉降），也包含显著的**季节性形变分量**，如因地下水波动导致的年/半年周期信号。

为了更准确地提取这些信息，我们常采用如下模型进行拟合：

$$
y\left(t\right)=y_0+vt+\sum_{k=1}^{2}\left[a_ksin\left(2\pi kt\right)+b_k\cos{\left(2\pi kt\right)}\right]+\varepsilon(t)
$$

其中：
- \\( v \\) ：线性速率（单位：mm/year）
- \\( y_0 \\) ：截距
- \\( t \\) ：时间（单位：十进制年，例如 2019.5）
- \\( a_k, b_k \\) ：三角函数系数（季节性形变信号），\\( k = 1 \\) 表示**年周期**，\\( k = 2 \\) 表示**半年周期**
- \\( \varepsilon(t) \\) ：噪声项，服从独立同分布，期望为 0

模型拟合后通过计算可以得到：

- 年/半年周期的**振幅**：  
  \\( A_k = \sqrt{a_k^2 + b_k^2} \\)  
- 年/半年周期的**相位**：  
  \\( \phi_k = \arctan\left( \frac{a_k}{b_k} \right) \\)

---

## 2. 📊脚本功能说明

> 下面是主要的 MATLAB 脚本说明，适用于一组格式统一的 GRD 位移时间序列数据，可建立一个model文件夹，所有操作在该文件夹进行。

- 📄 输入：
  - 将所有累积形变栅格数据`20*mask_ll_referenced.grd`链接至操作，例如：<br>
    `20200914_mask_ll_referenced.grd`<br>
    `20200928_mask_ll_referenced.grd`<br>
    `20200930_mask_ll_referenced.grd`<br>
  - 🌟🌟🌟所需脚本：文件较多，可下载解压后放至操作目录，或存放在自己的脚本库中，在matlab中设置永久路径。<br>
  📦 下载完整 MATLAB 实现脚本：
  
    [Seasonal_model.zip](/assets/files/seasonal_model.zip)

- 修改脚本`Seasonal_model.m`中参数信息:

  - 数据存放目录与结果输出目录：<br>
    `DataFolder='/media/student/model';`<br>
    `OutFolder='/media/student/model';`
    
  - GRD文件尺寸信息（`gmt grdinfo file.grd`即可查看数据信息 ）：<br>
    `mat_line=2570;` Y轴的行列数<br>
    `mat_col=2790;` X轴的行列数<br>
    🌟 请注意X和Y的顺序。

  - 日期文件信息：
    `sardate=load('dates.list');`<br>
    文件中每行一个日期，格式为`yyyymmdd`, 可运行命令生成：
    ```bash
    ls 20*mask_ll_referenced.grd | awk -F_ '{print $1}' > dates.list
    ```
  > 脚本中的核心拟合函数为 `line_ansef`，用户可自定义调用。

- 输出文件：<br>
    `linear_velocity.grd`  线性速率<br>
    `amp_annual.grd`  年周期振幅<br>
    `amp_semiannual.grd` 半年周期振幅<br>
    `phase_annual.grd` 年周期相位<br>
    `phase_semiannual.grd` 半年周期相位<br>
    `rms.grd` 残差<br>
    🌟请注意，如果需要将相位改为月度单位，需将脚本内容改为如下：
      `phase_annual(i)=qtan(d,c)*180/pi/30;` <br>
      `phase_semiannual(i)=qtan(f,e)*180/pi/30;`

🧠 所有数据最终按行列展开，逐像元进行拟合，最后再 reshape 为二维图像保存。

## 3. 💡单点的模型拟合

为了研究某个点的季节性形变特征信息，我们仅需简单的对单个点的时间序列拟合。

- 首先需要点的形变时间序列文件，参考之前的[形变时间序列提取](/posts/InSAR-timeseries/#10--形变时间序列提取)方法。

- 使用脚本压缩包中的`One_point_seasonal_model.m`脚本。在matlab中修改文件信息即可

  `file=load('P1_ts_disp.txt');`

即可在matlab工作区中得到模型参数信息，同时也提供了一个简单的图像输出：
![模型拟合](/assets/img/picture/modelfit2.png)


  
  






