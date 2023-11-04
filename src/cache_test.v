module main

import os { getenv }

fn test_get_home_dir() {
	var_name := $if windows {
		'USERPROFILE'
	} $else {
		'HOME'
	}
	assert get_home_dir()? == getenv(var_name)
}

fn test_get_npm_cache_path() {
	$if windows {
		assert get_npm_cache_path()! != ''
	} $else {
		assert get_npm_cache_path()! == '${getenv('HOME')}/.npm'
	}
}

fn test_get_cache_path() {
	$if windows {
		assert get_cache_path()! != ''
	} $else {
		assert get_cache_path()! == '${getenv('HOME')}/.npm/_npx'
	}
}

fn test_get_cached_pkgs() {
	_, _ := get_cached_pkgs()!
}
