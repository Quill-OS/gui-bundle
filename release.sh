#!/bin/bash -e

MKSQUASHFS_ARGS=('-b' '1048576' '-comp' 'xz' '-Xdict-size' '100%' '-always-use-fragments')

[ -z "${GITDIR}" ] && echo "Please provide the GITDIR environment variable." && exit 1
[ -z "${1}" ] && echo "Please provide the 'signature key' argument." && exit 1
[ -z "${2}" ] && echo "Please provide the 'version' argument." && exit 1

cd "${GITDIR}"

# Copying compiled binaries
cp "build/build_inkbox/inkbox" "content/inkbox/inkbox-bin"
cp "build/build_oobe-inkbox/oobe-inkbox" "content/inkbox/oobe-inkbox-bin"
cp "build/build_lockscreen/lockscreen" "content/inkbox/lockscreen-bin"

# Squashing packages
rm -rf "out/"
mkdir -p "out/update-bundle" && pushd "out/update-bundle"
echo "${2}" > "./version"
cp "${GITDIR}/content/license" "./license"
cp "${GITDIR}/content/changelog" "./changelog"
mksquashfs "${GITDIR}/content/inkbox" "./inkbox.isa" "${MKSQUASHFS_ARGS[@]}"
mksquashfs "${GITDIR}/content/qt" "./qt.isa" "${MKSQUASHFS_ARGS[@]}"
mksquashfs "${GITDIR}/content/python" "./python.isa" "${MKSQUASHFS_ARGS[@]}"
for f in *.isa; do
	if [ "${f}" != "*" ]; then
		openssl dgst -sha256 -sign "${GITDIR}/${1}" -out "${f}.dgst" "${f}"
	fi
done
sync

# Creating final GUI bundle
mksquashfs "${GITDIR}/out/update-bundle" "${GITDIR}/out/update.isa" "${MKSQUASHFS_ARGS[@]}"
sync

exit 0
