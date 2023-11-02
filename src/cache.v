import os { exists, getenv_opt, join_path, join_path_single, ls, read_file }
import prantlf.debug { new_debug }
import prantlf.osutil { execute }
import prantlf.pcre { pcre_compile }

const d = new_debug('npxcc')

const re_pkg_name = pcre_compile(r'^\s*"([^"]+)"\s*:\s*"([^"]+)"', pcre.opt_multiline) or {
	unreachable()
	unsafe { nil }
}

fn get_cached_pkgs() !(string, []string) {
	cache := get_cache_path()!
	if exists(cache) {
		d.log('list "%s"', cache)
		children := ls(cache)!
		return cache, children
	}
	d.log('not found "%s"', cache)
	return '', []string{}
}

fn get_pkg_info(cache_path string, pkg_dir string) !(string, string) {
	file_path := join_path(cache_path, pkg_dir, 'package.json')
	if exists(file_path) {
		d.log('read "%s"', file_path)
		file_content := read_file(file_path)!
		d.log('content "%s"', file_content)
		return if m := re_pkg_name.exec(file_content, 0) {
			name := m.group_text(file_content, 1) or { return unreachable() }
			ver := m.group_text(file_content, 2) or { return unreachable() }
			d.log('package "%s", version "%s"', name, ver)
			name, ver
		} else {
			error('unrecognmised package format: "${file_content}"')
		}
	}
	d.log('not found "%s"', file_path)
	return '', ''
}

fn get_cache_path() !string {
	mut cache := ''
	$if windows {
		cache = get_npm_cache_path()!
	} $else {
		cache = if home_dir := get_home_dir() {
			npm_cache := join_path_single(home_dir, '.npm')
			if exists(npm_cache) {
				npx_cache := join_path_single(npm_cache, '_npx')
				d.log('npx cache: "%s"', npx_cache)
				return npx_cache
			}
			get_npm_cache_path()!
		} else {
			get_npm_cache_path()!
		}
	}
	cache = join_path_single(cache, '_npx')
	d.log('npx cache: "%s"', cache)
	return cache
}

fn get_npm_cache_path() !string {
	return execute('npm config get cache')!
}

fn get_home_dir() ?string {
	var_name := $if windows {
		'USERPROFILE'
	} $else {
		'HOME'
	}
	return if home_dir := getenv_opt(var_name) {
		dhome_dir := d.rwd(home_dir)
		d.log('environment variable "%s" points to "%s"', var_name, dhome_dir)
		home_dir
	} else {
		d.log('environment variable "%s" is empty', var_name)
		none
	}
}

fn unreachable() IError {
	panic('unreachable code')
}
