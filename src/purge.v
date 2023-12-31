import os { exists, join_path_single, rmdir_all }

fn purge(names []string, dry_run bool, force bool, verbose bool) ! {
	mode := if dry_run {
		' (dry run)'
	} else {
		''
	}

	if names.contains('*') {
		cache := get_cache_path()!
		if verbose {
			println('cache: "${cache}"')
		}
		if exists(cache) {
			d.log('remove "%s"${mode}', cache)
			if !dry_run {
				rmdir_all(cache)!
			}
			if verbose {
				println('removed the whole cache${mode}')
			}
		} else {
			msg := 'cache not found'
			if force {
				if verbose {
					println(msg)
				}
			} else {
				if verbose {
					println(msg)
				} else {
					return error(msg)
				}
			}
			d.log('not found "%s"', cache)
		}
		return
	}

	cache, children := get_cached_pkgs()!
	if verbose {
		println('cache: "${cache}"')
	}
	mut remaining := unsafe { names }
	for i, child in children {
		name, ver := get_pkg_info(cache, child)!
		if name.len > 0 {
			if names.contains(name) {
				dir := join_path_single(cache, child)
				d.log('remove "%s"${mode}', dir)
				if !dry_run {
					rmdir_all(dir)!
				}
				remaining.delete(i)
				if verbose {
					println('removed: "${name}" (${ver})${mode}')
				}
			}
		}
	}

	if remaining.len > 0 {
		msg := 'not found: "${remaining.join('", "')}"'
		if force {
			if verbose {
				println(msg)
			}
		} else {
			if verbose {
				println(msg)
			} else {
				return error(msg)
			}
		}
	}
}
