# Kaoyaners

- 殷乔逸(Qiaoyi Yin)  qiaoyi_yin@foxmail.com
- 依力扎提·库尔班江(Elzat Kurbanjan)  m15150503973@163.com

## 开发环境

- Xcode: 10.0；
- Swift: 4.0；
- Swift第三方库: Alamofire, MJRefresh, SwifyJSON
- NodeJs + Express + Mongodb: 开发本地服务器，使用了Mongoose模块；

## 应用介绍

*Kaoyaners* 是一款专为考研学子设计的集学习、资源分享、社交等于一体的App。这款App的设计目的是为了使得广大的考研人能够互相分享资源，互相分享经验，互帮互助共同奋斗在考研路上，这款App崇尚“人人为我，我为人人”的氛围，分享与自用是这款App的主题。

> 虽然App设计尚未完善（譬如社交部分等）但是基本的主体框架和功能都以基本完成。

## 功能说明

``Kaoyaners``的第一级子目录下执行``pod install --repo-update``安装全部的依赖库。除此之外后端服务器地址需要在代码中更新，查看``ip``后将代码文件中的``NetworkInteract2Backend.swift``中的``serverURL``修改，然后先运行后端，在运行前端。

- **首页**：展示文章或者帖子，设计了页面交互譬如滑动翻页和刷新等。

    <div align=center><img width="210" height="420" src="https://github.com/SinestroEdmonce/iOS-Development_App/raw/master/Kaoyaners/Images/mimg2.gif"/></div>

- **资源**：展示不同分类下的**服务器端**资源文件，同样设计了页面交互譬如滑动翻页和刷新等。

    <div align=center><img width="210" height="420" src="https://github.com/SinestroEdmonce/iOS-Development_App/raw/master/Kaoyaners/Images/mimg8.gif"/></div>

- **分享**：设计了页面交互譬如滑动翻页，监听键盘避免遮挡，单元格交互等

    1. 上传文章或者帖子，可以输入文字内容或者图片内容，选择图片后可以选择插入方式，点击*发布/分享*按钮可以上传文章或帖子，按照图文混排的方式。

        <div align=center><img width="210" height="420" src="https://github.com/SinestroEdmonce/iOS-Development_App/raw/master/Kaoyaners/Images/mimg7.gif"/></div>
        
    2. 上传资源，需要输入资源名称，资源介绍，然后选择需要上传的资源，点击选择文件选取资源文件，若选取图片则会将多张图片打包上传等。

        <div align=center><img width="210" height="420" src="https://github.com/SinestroEdmonce/iOS-Development_App/raw/master/Kaoyaners/Images/mimg9.gif"/></div>

- **我的**：可以点击头像进行注册或登录，若已经登录那么点击将无效，可以退出账号则还原到默认账号``admin``，可以点击右上角齿轮按钮进入设置，可以点击不同的单元进行偏好设置，可以上传头像，上传完毕后将在页面更新

    <div align=center><img width="210" height="420" src="https://github.com/SinestroEdmonce/iOS-Development_App/raw/master/Kaoyaners/Images/mimg3.gif"/><img width="210" height="420" src="https://github.com/SinestroEdmonce/iOS-Development_App/raw/master/Kaoyaners/Images/mimg6.gif"/></div>

## 数据持久化

- 对User信息进行持久化，本地存储用户偏好；
- 对关注的圈子和收藏的文章进行持久化，同时存储在User后端数据库中；

## 不足之处

选择这个项目的出发点是由于项目搭档恰好经历考研，苦于交流的圈子小，消息渠道少，资源少，整体考研氛围比较松散独立，容易感到懈怠和退缩。然而如果能整合资源，扩大社交圈，拉近更多考研的学子的距离使他们能够互相鼓励，互相协助，那么相对而言复习的资料更多，考研动力更大，目标更加坚定。

但是由于时间有限，该App设计还不够完善，不过希望自己以后在空闲时间能够继续完成这个App，不仅会很有成就感，并且会提高自己的各项能力尤其是代码能力。

## 总结

- 这是第一次进行移动应用的开发，一个学期以来学习了很多东西，总的来说收获满满！感谢曹老师一个学期以来的教导，接触了很多新颖的东西，下学期软件体系结构已在课表上！
> 殷乔逸

- 学会了前后端开发的流程，对APP开发有了更深的认识，学一门语言还是要在机器上实践才可能真正掌握（说的我好像已经熟识了Swift了一样）感谢曹老板的指导！
> 依力扎提·库尔班江
