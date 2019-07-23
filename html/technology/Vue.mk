# Vue 学习笔记

### 1、node.js下载、安装略过

cnpm cache clear -force   清空缓存

根据install.js，脚本通过http.get下载chromediriver二进制文件。
但是zip文件已被移动，脚本不处理这种情况。

npm install chromedriver --chromedriver_cdnurl=http://cdn.npm.taobao.org/dist/chromedriver

npm audit
npm audit fix

(use `npm audit fix --force` to install breaking changes; or refer to `npm audit` for steps to fix these manually)
