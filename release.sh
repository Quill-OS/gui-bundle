#!/bin/bash -e

KOREADER_VERSION="2026.07.1"

if [ "${NO_COMPRESSION}" == "true" ]; then
	echo "Not using SquashFS compression"
	MKSQUASHFS_ARGS=('-b' '1048576' '-always-use-fragments' '-noI' '-noD' '-noF' '-noX')
elif [ "${GZIP_COMPRESSION}" == "true" ]; then
	MKSQUASHFS_ARGS=('-b' '1048576' '-comp' 'gzip' '-always-use-fragments')
else
	MKSQUASHFS_ARGS=('-b' '1048576' '-comp' 'xz' '-Xdict-size' '100%' '-always-use-fragments')
fi

cd "$(dirname ""${0}"")"
GITDIR="${PWD}"
[ -z "${1}" ] && echo "Please provide the 'signature key' argument." && exit 1
[ -z "${2}" ] && echo "Please provide the 'version' argument." && exit 1
[ -z "${3}" ] && echo "Please provide the 'binaries build folders location' argument." && exit 1

# Copying compiled binaries
pushd "content/inkbox"
cp "${3}/build_inkbox/inkbox" "./inkbox-bin"
cp "${3}/build_oobe-inkbox/oobe-inkbox" "./oobe-inkbox-bin"
cp "${3}/build_lockscreen/lockscreen" "./lockscreen-bin"
popd
# Downloading and extracting KOReader package
if [ ! -d "content/koreader" ]; then
	pushd "content"
	if grep -q "kt/private.pem" <<< "${1}"; then
		wget "https://github.com/koreader/koreader/releases/download/v${KOREADER_VERSION}/koreader-kindle-v${KOREADER_VERSION}.zip" -O koreader.zip
	else
		wget "https://github.com/koreader/koreader/releases/download/v${KOREADER_VERSION}/koreader-kobo-v${KOREADER_VERSION}.zip" -O koreader.zip
	fi
	unzip koreader.zip -x koreader.png && rm koreader.zip
	mkdir -p koreader/data/dict && pushd koreader/data/dict
	wget http://build.koreader.rocks/download/dict/gcide.tar.gz && tar -xvf gcide.tar.gz && mv gcide "GNU Collaborative International Dictionary of English" && rm gcide.tar.gz
	popd
	popd
fi

# Squashing packages
rm -rf "out/"
mkdir -p "out/update-bundle" && pushd "out/update-bundle"
echo "${2}" > "./version"
cp "${GITDIR}/content/license" "./license"
cp "${GITDIR}/content/changelog" "./changelog"
mksquashfs "${GITDIR}/content/inkbox" "./inkbox.isa" "${MKSQUASHFS_ARGS[@]}" -all-root
mksquashfs "${GITDIR}/content/qt" "./qt.isa" "${MKSQUASHFS_ARGS[@]}" -all-root
mksquashfs "${GITDIR}/content/koreader" "./koreader.isa" "${MKSQUASHFS_ARGS[@]}" -all-root
for f in *.isa; do
	if [ "${f}" != "*" ]; then
		openssl dgst -sha256 -sign "${1}" -out "${f}.dgst" "${f}"
	fi
done
sync

# Creating final GUI bundle
mksquashfs "${GITDIR}/out/update-bundle" "${GITDIR}/out/update.isa" "${MKSQUASHFS_ARGS[@]}" -all-root
sync

exit 0
