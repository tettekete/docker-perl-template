FROM amazonlinux:2

RUN yum install -y \
		tar			\
		patch		\
		gcc			\
		perl-devel	\
		make		\
		sudo		\
		tree		\
		which		\
		less		\
	&& yum clean all

# Perl::Build で perl をインストール
RUN curl -L https://raw.githubusercontent.com/tokuhirom/Perl-Build/master/perl-build | perl - 5.28.1 /opt/perl-5.28.1/

# Perl::Build でインストールした perl のパスを簡単に通すためのファイルを作成
RUN echo "export PATH=/opt/perl-5.28.1/bin:\$PATH" > /usr/local/src/use_local-perl

# cpanm
RUN source /usr/local/src/use_local-perl && \
	curl -L https://cpanmin.us | perl - App::cpanminus

# carton
RUN source /usr/local/src/use_local-perl && \
	cpanm Carton


# Carton でモジュールをインストール
RUN {\
		echo "requires 'perl','>=5.10.1';" ;\
		echo "requires 'Plack','1.0047';" ;\
	} > /opt/cpanfile

RUN source /usr/local/src/use_local-perl && \
	cd /opt	&& \
	carton install
