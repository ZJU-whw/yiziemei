@echo off

::安装mysqlserver
::要进到mysql\bin目录下执行安装 不然会出错
@echo "mvn clean package -Dmaven.test.skip=true -P nb"

call mvn clean package -Dmaven.test.skip=true -P nb

start %cd%\target

@pause