#!/bin/bash -e

if [ "$NO_COMPRESSION" = "true" ]; then
	echo "Not using SquashFS compression"
	MKSQUASHFS_ARGS=('-b' '1048576' '-always-use-fragments' '-noI' '-noD' '-noF' '-noX')
else
	MKSQUASHFS_ARGS=('-b' '1048576' '-comp' 'xz' '-Xdict-size' '100%' '-always-use-fragments')
fi

[ -z "${GITDIR}" ] && echo "Please provide the GITDIR environment variable." && exit 1
[ -z "${1}" ] && echo "Please provide the 'signature key' argument." && exit 1
[ -z "${2}" ] && echo "Please provide the 'version' argument." && exit 1
[ -z "${3}" ] && echo "Please provide the 'binaries build folders location' argument." && exit 1

cd "${GITDIR}"

# Copying compiled binaries
pushd "content/inkbox"
cp "${3}/build_inkbox/inkbox" "./inkbox-bin"
cp "${3}/build_oobe-inkbox/oobe-inkbox" "./oobe-inkbox-bin"
cp "${3}/build_lockscreen/lockscreen" "./lockscreen-bin"
popd

# Squashing packages
rm -rf "out/"
mkdir -p "out/update-bundle" && pushd "out/update-bundle"
echo "${2}" > "./version"
cp "${GITDIR}/content/license" "./license"
cp "${GITDIR}/content/changelog" "./changelog"
mksquashfs "${GITDIR}/content/inkbox" "./inkbox.isa" "${MKSQUASHFS_ARGS[@]}" -all-root
mksquashfs "${GITDIR}/content/qt" "./qt.isa" "${MKSQUASHFS_ARGS[@]}" -all-root
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
