[**English guide is here**](https://github.com/zaywalker/chevereto/blob/master/README.md)

[cheveretourl]: https://chevereto.com/
[cheveretoinstaller]: https://chevereto.com/download/file/installer
[cheveretogetstarted]: https://chevereto.com/get-started
[php]: https://hub.docker.com/_/php
[![chevereto](http://chevereto.com/app/themes/v3/img/chevereto-blue.svg)][cheveretourl]

# zaywalker/chevereto:installer - Chevereto 설치버전

[Chevereto][cheveretourl]는 강력하고 빠른 이미지 호스팅 웹서버로 다양한 기능의 이미지 호스팅 웹사이트를 단 몇 분이면 만들 수 있습니다. 

이 도커 파일은 [Chevereto Get Started][cheveretogetstarted] 페이지에 있는 [installer.php][cheveretoinstaller] 를 이용해서 [php 7.4 and apache2][php] 기반의 도커 베이스에 올립니다.

## 지원하는 태그

* `installer` - [installer script][cheveretoinstaller] 스크립트 사용 버전

## 데이터베이스 연결

[Chevereto][cheveretourl]는 Mysql 데이터베이스에 정보를 저장합니다. [Mysql](https://hub.docker.com/_/mysql/) 이나 [MariaDB](https://hub.docker.com/_/mariadb/) 컨테이너를 이용해서 호스팅할 수 있습니다.

데이터베이스 연결에 대한 정보는 위에서 설명한 환경 변수를 통해 컨테이너에 제공됩니다.

## 저장소 유지

[Chevereto][cheveretourl]는 사용자가 업로드한 이미지를 컨테이너의 `/var/www/html/images` 디렉터리에 저장합니다.

Chevereto를 관리하려면, `/var/www/html` 디렉터리를 로컬에 [마운트](https://docs.docker.com/engine/tutorials/dockervolumes/#data-volumes)하는 것을 권장합니다. 마운트된 로컬 디렉터리로 컨테이너를 다시 구동하거나 재설치를 해도 이미지와 Chevereto HTML 데이터 그리고 업데이트를 유지할 수 있습니다.

## 최대 이미지 크기

기본값으로 PHP의 최대 업로드 용량은 2MB로 설정되어있습니다. 이런 설정은 컨테이너의 `/var/www/html/.htaccess` 파일이나 마운트 된 로컬의 `/your_mount/.htaccess`를 업데이트해서 바꿀 수 있습니다.

> 기본값으로 Chevereto에서도 업로드 용량을 10MB로 제한하고 있는 것에 유의하세요. 따라서 `.htaccess`를 편집해도 Chevereto 설정 페이지 (CHEVERETO_URL/dashboard/settings/image-upload)에서 설정해줘야 합니다.

> 아래의 코드를 `.htaccess` 하단부에 추가하는것으로 제한을 10G로 바꿀 수 있습니다. 
```
php_value upload_max_filesize 10G
php_value post_max_size 10G
php_value memory_limit 1G
php_value max_execution_time 300
php_value max_input_time 300
```

## [역방향 프락시](https://en.wikipedia.org/wiki/Reverse_proxy)와 리얼 IP

Chevereto를 [역방향 프락시](https://github.com/jc21/nginx-proxy-manager)를 통해 서비스한다면, 컨테이너의 `/var/www/html/app/settings.php`파일이나 마운트 된 로컬의 `/your_mount/app/setting.php` 파일을 편집해줘야 합니다. 

> 아래의 코드를 `settings.php` 하단부에 추가하면 리얼 IP를 볼 수 있습니다.
```php
// Use X-Forwarded-For HTTP Header to Get Visitor's Real IP Address
if ( isset( $_SERVER['HTTP_X_FORWARDED_FOR'] ) ) {
        $http_x_headers = explode( ',', $_SERVER['HTTP_X_FORWARDED_FOR'] );

        $_SERVER['REMOTE_ADDR'] = $http_x_headers[0];
}
```

## 사용 예제

Chevererto를 MySQL과 바인딩해서 서비스하기 위해 [Docker-compose](https://docs.docker.com/compose/) / [Docker swarm](https://docs.docker.com/engine/swarm/)을 사용하는 것을 권장합니다. docker-compose.yaml는 하단의 예시를 참조해주세요.

### Docker compose

> 몇가지 값을 바꿔야 하는것에 유의하세요,
* Asia/Seoul - 시간대
* your_mysql_root_password - MySQL 관리를 위한 root 패스워드
* your_mysql_chevereto_dbname - Chevereto 데이터베이스 이름
* your_mysql_chevereto_username - Chevereto 데이터베이스의 사용자 이름
* your_mysql_chevereto_user_password - Chevereto 데이터베이스의 사용자 비밀번호
* /your_mount - Chevereto 컨테이너의 /var/www/html
* IP addresses - Chevereto 는 MySQL 에 서비스 이름으로 연결합니다만 보안을 위해서 바꿔주는것이 좋습니다.

```yaml
version: '2.1'
services:
    mysql-chevereto:
      container_name: chevereto-mysql
      image: mariadb:10.2
      restart: always
      volumes:
        - mysql-vol-1:/var/lib/mysql/
      environment:
        # 시간대나 다른 값들을 알맞게 바꿔주세요
        - TZ=Asia/Seoul
        - MYSQL_ROOT_PASSWORD=your_mysql_root_password
        - MYSQL_DATABASE=your_mysql_chevereto_dbname
        - MYSQL_USER=your_mysql_chevereto_username
        - MYSQL_PASSWORD=your_mysql_chevereto_user_password
      networks:
        chevereto-network:
          # IP 주소를 바꿔주세요
          ipv4_address: 172.23.1.20
          aliases:
            - mysql

    web-chevereto:
      container_name: chevereto-web
      image: zaywalker/chevereto:installer
      restart: always
      depends_on:
        - mysql-chevereto
      volumes:
        # 마운트 위치를 바꿔주세요
        - /your_mount:/var/www/html
      environment:
        # 시간대를 바꿔주세요
        - TZ=Asia/Seoul
      networks:
        chevereto-network:
          # IP 주소를 바꿔주세요
          ipv4_address: 172.23.1.10
          aliases:
            - web

volumes:
  mysql-vol-1:

networks:
  chevereto-network:
    driver: bridge
    ipam:
      driver: default
      config:
        # 서브넷을 바꿔주세요
        - subnet: 172.23.1.0/24
```

`docker-compose.yaml`이 준비되었으면 다음과 같이 실행시켜봅시다.

```bash
docker-compose up -d 
```

이러면 서비스가 실행됩니다.

### 독립 실행

```bash
docker run --name chevereto-web -d \
    -v /your_mount:/var/www/html \
    zaywalker/chevereto:installer
```

## Chevereto 설치

컨테이너가 실행되었고 프락시에 잘 연결하셨다면, **installer.php**를 붙인 주소로 Chevereto를 설치할 수 있습니다.

```
http://your.chevereto.web/installer.php
```
그리고 인스툴 과정을 따라가기만 하면 되며, 몇 가지 값을 설정해주면 됩니다.

* License key
     - 구입한 라이선스 키를 넣거나 스킵하여 Chevereto-Free 버전을 설치합니다
* cPanel access
     - cPanel 계정입니다. 없으면 그냥 스킵하세요
* Database Host
     - MySQL 서버 주소입니다. docker compose 예제를 따르셨다면 `mysql-chevereto`입니다
* Database Port
     - MySQL 서버 포트입니다. docker compose 예제를 따르셨다면 `3306`입니다
* Database Name
     - MySQL chevereto 데이터베이스 이름입니다. docker compose 예제를 따르셨다면 `your_mysql_chevereto_dbname`입니다
* Database User
     - MySQL chevereto 데이터베이스의 사용자 이름입니다. docker compose 예제를 따르셨다면 `your_mysql_chevereto_username`입니다
* Database User password
     - MySQL chevereto 데이터베이스의 사용자 비밀번호입니다. docker compose 예제를 따르셨다면 `your_mysql_chevereto_user_password`입니다


