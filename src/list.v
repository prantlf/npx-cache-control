fn list(verbose bool) ! {
	cache, children := get_cached_pkgs()!
	if verbose {
		println('cache: "${cache}"')
	}
	for child in children {
		name, ver := get_pkg_info(cache, child)!
		if name.len > 0 {
			if verbose {
				println('package: "${name}" (${ver})')
			} else {
				println(name)
			}
		} else if verbose {
			println('empty directory: "${child}"')
		}
	}
}
