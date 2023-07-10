#! /bin/bash

export DEBIAN_FRONTEND=noninteractive
export TZ=Asia/Shanghai

cp -Rv apt.sh /apt.sh
cp -Rv dak.sh /dak.sh
cp -Rv dak.dev /dak.dev
cp -Rv dak.start /dak.start

/apt.sh/updatepkg.sh
/dak.sh/install.sh
/dak.sh/configure.sh
/dak.dev/init-dev.sh
