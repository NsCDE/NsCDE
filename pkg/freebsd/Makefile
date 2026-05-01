# FreeBSD Port for NsCDE-zh
# Author: wenyinos <admin@wenyinos.com>

PORTNAME=	NsCDE-zh
DISTVERSION=	2.3.10
CATEGORIES=	x11-wm

MAINTAINER=	admin@wenyinos.com
COMMENT=	Retro UNIX desktop environment (CDE look) - Chinese Localization
WWW=		https://github.com/wenyinos/NsCDE-zh

LICENSE=	GPLv3
LICENSE_FILE=	${WRKSRC}/COPYING

BUILD_DEPENDS=	ksh93:shells/ksh93 \
		gsed:textproc/gsed
LIB_DEPENDS=	libX11.so:x11/libX11 \
		libXext.so:x11/libXext \
		libXpm.so:x11/libXpm
RUN_DEPENDS=	ksh93:shells/ksh93 \
		gsed:textproc/gsed \
		fvwm3:x11-wm/fvwm3 \
		xsettingsd:x11/xsettingsd \
		stalonetray:x11/stalonetray \
		xdotool:x11/xdotool \
		xterm:x11/xterm \
		graphics/ImageMagick7 \
		groff:textproc/groff \
		python3:lang/python3 \
		${PYTHON_PKGNAMEPREFIX}psutil>=0:sysutils/py-psutil@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}pyxdg>=0:devel/py-pyxdg@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}pyyaml>=0:devel/py-pyyaml@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}qt5-pyqt>=0:devel/py-qt5-pyqt@${PY_FLAVOR} \
		gettext:devel/gettext \
		noto-basic>0:x11-fonts/noto-basic \
		noto-sc>0:x11-fonts/noto-sc \
		xrdb:x11/xrdb \
		xset:x11/xset \
		xprop:x11/xprop \
		xdpyinfo:x11/xdpyinfo \
		xrandr:x11/xrandr \
		xdg-utils:devel/xdg-utils

USES=		autoreconf gettext-tools gmake iconv localbase python xorg
USE_GITHUB=	yes
GH_ACCOUNT=	wenyinos
GH_TAGNAME=	v${DISTVERSION}_zh
USE_XORG=	x11 xext xpm

GNU_CONFIGURE=	yes
CONFIGURE_ARGS=	--libexecdir=${PREFIX}/lib

pre-configure:
	(cd ${WRKSRC} && ./autogen.sh)

post-install:
	(cd ${STAGEDIR}${PREFIX} && \
		${FIND} . \( -type f -o -type l \) | \
		${SED} 's,^./,,' | ${SORT} > ${TMPPLIST})
	(cd ${STAGEDIR}${PREFIX} && \
		${FIND} . -type d -empty | \
		${SED} 's,^./,@dir ,' | ${SORT} >> ${TMPPLIST})

.include <bsd.port.mk>
