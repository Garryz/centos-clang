FROM garryzhengkj/centos-gcc

RUN cd /tmp \
	&& wget -O llvm.tar http://releases.llvm.org/4.0.0/llvm-4.0.0.src.tar.xz \
	&& wget -O clang.tar http://releases.llvm.org/4.0.0/cfe-4.0.0.src.tar.xz \
	&& wget -O extra.tar http://releases.llvm.org/4.0.0/clang-tools-extra-4.0.0.src.tar.xz \
	&& mkdir -p llvm \
	&& tar -xf llvm.tar -C llvm --strip-components=1 \
	&& mkdir -p llvm/tools/clang \
	&& tar -xf clang.tar -C llvm/tools/clang --strip-components=1 \
	&& mkdir -p llvm/tools/clang/tools/extra \
	&& tar -xf extra.tar -C llvm/tools/clang/tools/extra --strip-components=1 \
	&& mkdir build \
	&& cd build \
	&& source /opt/rh/python33/enable \
	&& cmake -G "Unix Makefiles" \ 
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_TARGETS_TO_BUILD=X86 \
		../llvm \
	&& make -j4 \
	&& make install \
	&& yum clean all \
	&& find /usr/share \
		-type f \
		-regextype posix-extended \
		-regex '.*\.(jpg|png)$' \
		-delete \
	&& rm -rf /etc/ld.so.cache \
	&& rm -rf /sbin/sln \
	&& rm -rf /usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /opt/rh/python27/root/usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /opt/rh/python33/root/usr/{{lib,share}/locale,share/i18n,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
	&& rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*
