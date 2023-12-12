import os { join_path_single, rmdir_all }

fn clear(verbose bool) ! {
	cache, children := get_cached_pkgs()!
	if verbose {
		println('cache: "${cache}"')
	}
	for child in children {
		name, _ := get_pkg_info(cache, child)!
		if name.len == 0 {
			dir := join_path_single(cache, child)
			println(child)
			rmdir_all(dir)!
		}
	}
}
