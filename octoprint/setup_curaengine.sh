#!/bin/sh

# Dependency install
apk update
apk add --no-cache protobuf-dev
apk add --no-cache --virtual .build \
  git alpine-sdk

# CuraEngine install
git clone https://github.com/Ultimaker/CuraEngine.git -b 15.04.6 /home/user/cura
cd /home/user/cura
# Alpine compatibility patch
patch -p1 <<EOF
diff --git a/src/main.cpp b/src/main.cpp
index d1d93190..0d8670ca 100644
--- a/src/main.cpp
+++ b/src/main.cpp
@@ -4,7 +4,7 @@
 #include <string.h>
 #include <sys/time.h>
 #include <signal.h>
-#if defined(__linux__) || (defined(__APPLE__) && defined(__MACH__))
+#if defined(__GLIBC__) || (defined(__APPLE__) && defined(__MACH__))
 #include <execinfo.h>
 #include <sys/resource.h>
 #endif
@@ -51,7 +51,7 @@ using namespace cura;
 
 int main(int argc, char **argv)
 {
-#if defined(__linux__) || (defined(__APPLE__) && defined(__MACH__))
+#if defined(__GLIBC__) || (defined(__APPLE__) && defined(__MACH__))
     //Lower the process priority on linux and mac. On windows this is done on process creation from the GUI.
     setpriority(PRIO_PROCESS, 0, 10);
 #endif
EOF
make
mv /home/user/cura/build/CuraEngine /usr/bin/

# Cleanup
apk del .build
rm -rf /home/user/cura /var/cache/apk/* $0
