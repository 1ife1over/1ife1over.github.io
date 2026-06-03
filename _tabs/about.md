---
# the default layout is 'page'
icon: fas fa-info-circle
order: 4
---

<!-- > Add Markdown syntax content to file `_tabs/about.md`{: .filepath } and it will show up on this page.
{: .prompt-tip } -->

---

## 👋 你好，欢迎来到我的博客网站！

<style>
  .about-carousel {
    position: relative;
    width: min(100%, 760px);
    aspect-ratio: 16 / 9;
    margin: 1.5rem auto;
    overflow: hidden;
    border-radius: 8px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.14);
  }

  .about-carousel > a,
  .about-carousel > img {
    position: absolute;
    inset: 0;
    display: block;
    opacity: 0;
    animation: about-carousel-fade 8s infinite;
  }

  .about-carousel img {
    width: 100%;
    height: 100%;
    display: block;
    object-fit: cover;
  }

  .about-carousel > a:nth-of-type(2),
  .about-carousel > img:nth-of-type(2) {
    animation-delay: 4s;
  }

  @keyframes about-carousel-fade {
    0%,
    45% {
      opacity: 1;
    }

    55%,
    100% {
      opacity: 0;
    }
  }
</style>

<div class="about-carousel" aria-label="关于页面图片轮播">
  <img src="/assets/img/picture/about.jpg" alt="关于页面照片 1">
  <img src="/assets/img/picture/about2.jpg" alt="关于页面照片 2">
</div>

我是一名来自 **中国矿业大学（北京）** 的博士研究生，专业为 **测绘科学与技术**，研究方向是 **InSAR 技术与应用**。

---

## 📌 建站目的

建立这个博客的初衷是：

- 记录 InSAR 学习过程中的笔记、心得与问题；
- 分享常用工具（如 GMTSAR、ARCGIS、MATLAB）的使用经验；
- 提供一些我自己撰写的资料和代码，方便他人查阅与参考；
- 留作自己科研道路的一份日志。

---

## 📮 联系方式

- GitHub: [@1ife1over](https://github.com/1ife1over)
- Email: chaohsiangchun@foxmail.com

欢迎大家与我交流！

---
