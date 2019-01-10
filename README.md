<h1 align="center">🌟 Flutter_LED_Marquee © 🌟</p>


## 🌞 Screenshots
<div>
    <img src='./Screenshots/flutter_led_marquee.gif' width=680>
</div>

## 依赖
> [RealRichText](https://github.com/bytedance/RealRichText) 

> [marquee](https://github.com/BeanWei/marquee)

> [card_settings](https://github.com/codegrue/card_settings)

> [permission_handler](https://github.com/BaseflowIT/flutter-permission-handler)

## 这skr啥？
> Flutter 制作的 LED 跑马灯弹幕，手持弹幕，演唱会打Call必备。

## 怎么用?
> 已Release初版，可以正常使用。
> 自定义滚动文字内容、大小、颜色、滚动速度，文本支持富文本，双击文字滚动的页面即可进入自定义页面，后期会专注于滚动文本的风格样式上升级优化。
> V1.1.0. 支持图片滚动.

## TODO
- [X] ~~支持自定义文字滚动速度~~
- [X] 支持(本地)图片作为文本
- [ ] 支持混合风格的文本【这个现在苦于还没想到一个好看的编辑界面所以暂时放弃。后期如果想到更美观优雅的UI布局则会加入.】
- [ ] 支持自定义文字风格
-----------------------------------------------------------------
- [X] ~~支持双击返回退出 (设置页面双击返回询问退出，跑马灯页面禁用返回按钮/双击屏幕返回设置页面)~~
- [ ] 语言国际化？！
- [ ] 分离代码中的常量，支持i18 ？！, 顺便写份 English README?!!

## Bug/issue
> 已知bug: 
-    文字大小过大后，emoji将会失效。[我在flutter仓库下提了这个issue，待官方解决](https://github.com/flutter/flutter/issues/26263)
-    图片插入的滚动，文本过短会出现图片只能滚动一半就消失的情况，目前原因未知.
-    ~~无法获取状态栏高度~~
-    ~~打包后的Apk无法全屏显示emmmm (Dev: Android 8.0, 模拟器5.0正常).~~(Release版V1.0.0打包后没有此问题？？？黑人❓.jpg)

## LICENSE

@MIT