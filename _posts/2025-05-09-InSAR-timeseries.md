---
title: "🛰️ Sentinel-1 时间序列 InSAR 数据处理完整流程 (基于GMTSAR)"
date: 2025-05-09 10:00:00 +0800
categories: [InSAR, 数据处理]
tags: [Sentinel-1, 数据处理, GMTSAR, InSAR]
pin: false
toc: true
comments: true
author: 1ife1over
---


> 🎯 本文将详细介绍如何使用 GMTSAR 软件对 Sentinel-1 数据进行时序 InSAR 处理，包括数据准备、预处理、配准、干涉图生成、相位解缠、最终时序分析等步骤。

---
## 🧭 处理流程概览

1. 📁 数据准备  
2. 📚 主/辅图像配准   
3. 🌈 差分干涉  
4. 🌊 合并子条带  
5. 🗺️ 检查干涉对 
6. 🔓 相位解缠 
7. ☁️ GACOS大气校正
8. 🛠️ SBAS解算
9. 🧵 SBAS后处理
10. 📈 形变时间序列提取 


---
## 1. 📁 数据准备

首先按照子条带`F1` `F2` `F3`，对数据进行处理，文件目录设置如下：
![图片说明文字](/assets/img/picture/dir.png)

- 将相应的`*.tiff` `*.xml` 文件放置在`raw/`文件夹

    [link_S1.csh](/code/link_S1.csh)

    ```bash
    link_S1.csh Sentinel-1/data/path swathnumber
    ```


- 将轨道`*.EOF` 文件放置在`raw/`文件夹

    [link_S1_orbits.csh](/code/link_S1_orbits.csh)

    ```bash
    link_S1_orbits.csh Sentinel-1/orbit/path
    ```
    > 此时会生成一个`data.in`文件，其中具有数据文件名（无后缀）和轨道，用`:`分隔

- 将DEM`dem.grd`文件分别放置在`raw/` `topo/`文件夹

---
## 2. 📚 主/辅图像配准 

-  ⚙️ 首先进行粗配准，运行脚本
    ```bash
    preproc_batch_tops.csh data.in dem.grd 1
    ```
     > 完成后会生成一个`baseline_table.dat`文件，其中包含数据的基线信息。可以将该文件移动至上层目录, 避免精密配准中，该文件重复生成。

     `S1_20180201_ALL_F1 2018031.1874165505 1491 19.088688436880 56.434825714407 S1_20180207_ALL_F1 2018037.1879020806 1497 -55.518698696406 -34.273719507112 S1_20180213_ALL_F1 2018043.1874162052 1503 -41.389270891689 -22.026755662146 S1_20180219_ALL_F1 2018049.1878994363 1509 -50.211739839015 -25.142105633455 S1_20180225_ALL_F1 2018055.1874136333 1515 -20.370088939888 16.909205059498 S1_20180303_ALL_F1 2018061.1878994068 1521 -45.495652914617 -13.865048265740`
    ```bash
     mv baseline_table.dat ../
    ```
    - 检查`baseline.ps`文件，在基线图中间选择超级主影像，使所有影像在下一步的精密配准中与其配准。
    ![图片说明文字](/assets/img/picture/p6.png)

    
- ⚙️ 再进行精密配准 
    将`data.in`中超级主影像所在行移动到文件第一行，然后进行精密配准

    - 运行脚本，进行精密配准
    ```bash
    preproc_batch_tops.csh data.in dem.grd 2
    ```
    > 在其余子条带`F2` `F3`中重复上述操作

---    
## 3. 🌈差分干涉 
- 🧾 首先准备干涉列表，例如在`F1`目录下运行：
    ```bash
    select_pairs.csh baseline_table.dat 50 100
    ```
    > 注意：50是时间基线阈值，干涉对时间间隔小于50；100是垂直极限阈值，干涉对垂直基线阈值小于100米。脚本会生成满足条件的`intf.in`文件，如下所示：
     
    `S1_20180508_ALL_F1:S1_20180514_ALL_F1`<br>
    `S1_20180508_ALL_F1:S1_20180526_ALL_F1`<br>
    `S1_20180508_ALL_F1:S1_20180607_ALL_F1`<br>
    `S1_20180508_ALL_F1:S1_20180520_ALL_F1 `<br>

    同时也会生成时空基线图，检查是否有未连接的影像，手动添加干涉对，使时空基线图完整，没有单独的干涉对或影像。
    
    手动调整后，可通过代码重新绘制新的时空基线图

    [plot_baseline.csh](/code/plot_baseline.csh)

    ```bash
    plot_baseline.csh intf.in baseline_table.dat
    ```

 - 🧾 修改配置文件`batch_tops.config` 

    `"# 1 - start from make topo_ra"`<br>
    `"# 2 - start from make and filter interferograms, unwrap and geocode"`<br>
    `"proc_stage = 1"` <br>
    🌟🌟🌟默认为1，从反向地理编码，生成topo_ra.grd开始。topo_ra.grd文件生成以后，可修改为2，进行并行处理

    `master_image = S1_20180426_ALL_F1`<br>
    🌟修改为对应的超级主影像。注意F1 F2 F3也需要对应

    `range_dec = 8`<br>
    `azimuth_dec = 2`<br>
    🌟多视参数调整，若研究区很小，可修改为4：1
    
    `dec_factor = 1`<br>
    🌟小范围取1,大范围取2，分辨率会降低，提高运算效率

- 🌈🌈🌈 差分干涉！！！
    - 建议先将batch_tops.config中proc_stage改为1，对一个干涉对进行干涉，并检查。

    ```bash
    head -1 intf.in > one.in
    intf_tops.csh one.in batch_tops.config
    ```
    - 一旦完成，再次编辑batch_tops.config，将proc_stage改为2，跳过创建topo_ra文件。便可进行并行干涉处理。

    ```bash
    intf_tops_parallel.csh intf.in batch_tops.config 10
    ```
    所有干涉对都存放在`intf_all`文件夹中，干涉图如下图所示
    ![图片说明文字](/assets/img/picture/phasefilt2.png)

    > 在其余子条带`F2` `F3`中重复上述操作

---
## 4. 🌊 合并子条带 

- 首先制作merge.in文件，使用`create_merge_input.csh`脚本
    ```bash
    create_merge_input.csh intf_list path mode 
    ```
    > mode 0 是合并 3 个subswaths, mode 1 是合并 F1/F2, mode 2 is 合并 F2/F3<br>
    > 例如: `create_merge_input.csh intflist .. 0 > merge.in`
- ⚠️注意将含有超级主影像日期的行全部置顶，确保所有图像都使用相同的坐标处理，并且最终网格大小相同

- 将配置文件`batch_tops.config`复制到`merge`目录，`dem.grd`也链接过来。
    ```bash
    cp ../F2/batch_tops.config .
    ln -s ../topo/dem.grd .
    ```
- 合并子条带
    运行脚本：
    ```bash
    merge_batch.csh merge.in batch_tops.config
    ```
    在合并完第一个干涉对后，会生成`trans.dat`文件。
    - 💡 （可选）若干涉对数量巨大，可选择并行操作，需要在生成`trans.dat`文件后，终止上个命令。运行并行脚本：
        ```bash
         merge_batch_parallel.sh inputfile config_file
        ```

---
## 5. 🗺️ 检查干涉对
> 由于数据本身、处理过程、操作失误等因素，部分干涉对出现错误，我们需要检查并剔除错误干涉对

- 我们先将干涉图绘制出来，使用脚本：

    [select_phasefilt.csh](/code/select_phasefilt.csh)

    ```bash
    ./select_phasefilt.csh mode
    ```
    > mode 1将建立`phasefilt_all`文件夹，汇总所有的干涉对以便查阅。错误干涉图在此删除即可。
    > mode 2将剔除的干涉图对应的文件夹移动到`rm`文件夹中。

---    
## 6. 🔓 相位解缠 
> 相位解缠是InSAR时间序列处理中最耗时的步骤之一。在平坦干燥地区，解缠速度较快；而在地形复杂，植被覆盖的地区，相位解缠准确度较低。

- 在`merge`目录中，首先制作一个干涉图列表🧾
    ```bash
    ls -d 20* > intf.list
    ```
- 运行解缠脚本
    ```bash
    unwrap_intf.csh intf.list
    ``` 
    > 运行前需要先修改解缠参数<br>
    >  `"snaphu.csh correlation_threshold maximum_discontinuity [<rng0>/<rngf>/<azi0>/<azif>]"` <br>
    💡相干性阈值`correlation_threshold`一般选0.02 - 0.1，`maximum_discontinuity`地震相位跳跃，一般取0，`[<rng0>/<rngf>/<azi0>/<azif>]`为解缠范围，默认全部解缠。

- 🌟🌟🌟通常为提高运算效率，我们选择并行解缠

    [unwrap_parallel.csh](/code/unwrap_parallel.csh)

    ```bash
    ./unwrap_parallel.csh intf.list 10
    ``` 
    当前目录需要放置一个unwrap_intf.csh文件，注意与之前的不同，不需要循环语句，内容大致如下：<br>
    
    [unwrap_intf.csh](/code/unwrap_intf.csh)

    ```bash
    cd $1
    snaphu[_interp].csh 0.02 0 
    cd ..
    ```    

---
## 7. ☁️ GACOS大气校正
> GACOS大气校正能够较好的去除与地形相关的对流层大气误差, 通常我们用GACOS进行大气校正。

- 在`merge`目录下，我们选择并行gacos校正

    [make_gacos_correction_parallel.csh](/code/make_gacos_correction_parallel.csh)<br>
    [make_gacos_correction.csh](/code/make_gacos_correction.csh)

    ```bash
    make_gacos_correction_parallel.csh intflist Ncores
    ```
    > 脚本会调用`make_gacos_correction.csh`脚本进行大气校正，需要修改参数信息：<br>
     `set gacos_path = /GACOS_path/ # GACOS file (*.ztd, *.rsc) path`<br>
     `set pixel_center = 41347`<br>
     `set line_center = 2422`<br>
     💡这是参考点的雷达坐标，一定要修改，选择研究区内稳定参考点。

    - 地理坐标系转雷达坐标系（参考点）

        ```bash
        proj_ll2ra_ascii.csh trans.dat points_ll.txt points_ra.txt
        ```

        > 至少需要三个点才能转换，三个点不能离得太近，不能在一条直线。<br>
            格式为`x` `y` `name`

---
## 8. 🛠️ SBAS解算

- 准备输入文件，使用脚本自动生成，需要将`intf.in`和 `baseline_table.dat`复制到SBAS目录，运行：
    ```bash
    prep_sbas.csh intf.in baseline_table.dat ../merge unwrap.grd corr.grd
    ```
    > 若采用了GACOS大气校正，`unwrap.grd`应改为`unwrap_gacos_corrected_detrended.grd`
    > 脚本会生成`intf.tab`和`scene.tab`，以及一行简单的SBAS指令

- 我们在命令行输入sbas指令：

    ```bash
    sbas intf.tab scene.tab N S xdim ydim [-atm ni] [-smooth sf] [-wavelength wl] [-incidence inc] [-range -rng] [-rms] [-dem]
    ```

    > 输入参数:<br>
    `intf.tab           --  干涉对列表`<br>
    `scene.tab          --  SAR数据列表（天数从2014年1月1日起算）`<br>
    `N                  --  干涉对数量`<br>
    `S                  --  SAR数据的数量`<br>
    `xdim and ydim      --  干涉图的尺寸`<br>
    `-smooth sf         --  平滑因子，默认为0，一般选3`<br>
    `-atm ni            --  大气校正（CPS方法）迭代次数，默认为0(跳过校正)，一般选3`<br>
    `-wavelength wl     --  雷达波长`<br>
    `-incidence theta   --  入射角，在xml中可以查看（incidence）`<br>
    `-range rng         --  雷达到干涉图中心的距离，在PRM文件中可以查看（near range）`<br>
    `-rms               --  形变速率的均方根误差 rms.grd`<br>
    `-dem               --  输出的dem误差 dem_err.grd`<br>
    `-mmap              --  使用硬盘代替运行内存，降速明显`<br>
    `-robust            --  only work with -atm turnned on, estimate velocity with records that has atm correction`<br>
    > 输出参数:<br>
    `disp_##.grd         --  累积形变量 (mm) `<br>
    `vel.grd             --  形变速率 (mm/yr)`<br>

---
## 9. 🧵 SBAS后处理
> 求出的`disp_##.grd`和`vel.grd` 需要进一步处理才能变为我们最终的结果。

- 首先修改文件名，将`disp_##.grd`修改为日期命名，运行脚本：

    [post_sbas.csh](/code/post_sbas.csh)

    ```bash
    post_sbas.csh
    ```
- 然后进行掩膜和地理编码，这两步同时进行。此时的数据还是雷达坐标系，需转为地理坐标系
  
  - 先进入merge目录计算干涉对平均相干性，操作如下

    [mask_meancorr.csh](/code/mask_meancorr.csh)

    ```bash
    ls */corr.grd > corr.list
    stack_corr.csh corr.list meancorr.grd
    mask_meancorr.grd meancorr.grd thresholds
    ```    
    
    > thresholds一般取0.12

  - 将相干性阈值文件链接到SBAS目录，运行脚本：

    [proj_disp_ra2ll.csh](/code/proj_disp_ra2ll.csh)
    
    ```bash
    proj_disp_ra2ll.csh
    ``` 

    > 生成`yyyymmdd_mask_ll.grd` 与 `vel_mask_ll.grd`文件

- 接着进行参考点校正，使用脚本
    
    ```bash
    make_reference.csh
    ``` 

    > 生成`yyyymmdd_mask_ll_referenced.grd` 与 `vel_mask_ll_referenced.grd`文件

- 绘制累积形变时间按序列图

    [plot_disp_ll_zxj.csh](/code/plot_disp_ll_zxj.csh)

    ```bash
    ls 20*referenced.grd > disp_referenced.list
    plot_disp_ll_zxj.csh disp_referenced.list -300 100
    ``` 
- 绘制形变速率图

    [plot_grd.csh](/code/plot_grd.csh)

    ```bash
    plot_grd.csh vel_mask_ll_referenced.grd -60 20
    ``` 
    > 该脚本适用于绘制任何WGS84坐标的栅格数据

- grd文件转kml, 用于在Googleearth中查看

    ```bash
    grd2kml.csh vel_file cpt_flie 
    ```

---
## 10. 📈 形变时间序列提取 

> 时间序列分析是InSAR的关键环节，我们在这里介绍如何提取一些点位的时间序列

- 首先需要创建一个`points.list`, 里面每一行包含一个点的信息, 格式为`x` `y` `name`<br>
    同时需要存在一个`grd_list`, 即我们要提取的累计形变栅格文件，一般为`disp_referenced.list`，执行脚本即可生成特征点的时间序列

    [extract_ts_std.csh](/code/extract_ts_std.csh)

    ```bash
    extract_ts_std.csh 
    ```

    > 脚本中，`gmt grdclip mask.grd -Sa0.2/NaN -Sb0.2/1 -Gmask.grd`，其中0.2即200米圆形范围内取平均，可根据需求修改。

- 若需要快速提取特征点的时间序列，且不需要范围内取平均，可采用以下脚本，能够大大提高提取速度

    [extract_ts_track.csh](/code/extract_ts_track.csh)

    ```bash
    extract_ts_track.csh
    ``` 

- 使用以下脚本可以快速绘制时间序列图像

    [plot_timeseries.csh](/code/plot_timeseries.csh)

    ```bash
    plot_timeseries.csh name_ts_disp.txt
    ``` 






    
 










    
    
