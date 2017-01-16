for dir in systemd-*; do
    [ -d "$dir" ] || continue

    echo "Patching systemd registry dep"

    patch -p1 -d "$dir" < "$patchRegistryDeps/systemd.patch"
done
