# TUNA mirrors 主页

## 运行 Demo

### 直接编译

本站使用 Jekyll 编写，并使用 babel 编译 ECMAScript6，因此必须安装 ruby >= 2.0 和 nodejs.

### For Centos
1.安装 nodejs
```
yum install nodejs
```
2.安装 ruby 2.2.4 and rubygems

Step 1: Install Required Packages
```
yum install gcc-c++ patch readline readline-devel zlib zlib-devel
yum install libyaml-devel libffi-devel openssl-devel make
yum install bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
```
Step 2: Compile ruby 2.2.4 source code
```
wget -c https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.4.tar.gz
```
Step 3: Install rubygems
```
wget -c https://rubygems.org/rubygems/rubygems-2.4.8.tgz
ruby setup.rb
```
3. 安装 bundle 和 build
```
gem install bundle
gem install build
```
4. Fork mirrors source code

```
bundle install
jekyll build
```

### Build In Docker
```
cd mirror-web
docker build -t builden -f Dockerfile.build .
docker run -it -v /path/to/mirror-web/:/data builden
```

为正常运行，一些动态数据文件需要下载

```
wget https://mirrors.tuna.tsinghua.edu.cn/static/tunasync.json -O static/tunasync.json
wget https://mirrors.tuna.tsinghua.edu.cn/static/tunet.json -O static/tunet.json
mkdir -p static/status
wget https://mirrors.tuna.tsinghua.edu.cn/static/status/isoinfo.json -O static/status/isoinfo.json
```

之后 `jekyll serve` 即可运行 demo.


# queckstart 

```bash

docker run -itd \
    --name=web \
    --net=host \
    --restart=always \
    -v /home/mirror-web/:/data \
    -v /etc/localtime:/etc/localtime:ro \
    registry.cn-beijing.aliyuncs.com/anglecv/mirror-web:v1 \
    jekyll serve

```


## nginx编译后生成

```bash

load_module modules/ngx_http_js_module.so;
load_module modules/ngx_http_fancyindex_module.so;

map $http_user_agent $isbrowser {
 default 0;
 "~*validation server" 0;
 "~*mozilla" 1;
}

fancyindex_header /fancy-index/before;
fancyindex_footer /fancy-index/after;
fancyindex_exact_size off;
fancyindex_time_format "%d %b %Y %H:%M:%S +0000";
fancyindex_name_length 256;

error_page 404 /404.html;

location /fancy-index {
 internal;
 root /path/to/mirror-web/_site;
 subrequest_output_buffer_size 100k;
 location = /fancy-index/before {
   js_content fancyIndexBeforeRender;
 }
 location = /fancy-index/after {
   js_content fancyIndexAfterRender;
 }
}

js_path /path/to/mirror-web/static/njs;
js_include /path/to/mirror-web/static/njs/all.njs;

location / {
 root /path/to/mirrors;
 fancyindex on;
}

```
