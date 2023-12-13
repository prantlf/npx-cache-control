import prantlf.cargs { Input, parse }

const version = '1.3.1'

const usage = 'Lists and purges packages cached when running npx.

Usage: npxcc [options] <command> [parameters]

Commands:
  ls|list                       lists packages stored in the npx cache
	purge|rm|remove|un|uninstall  removes packages from the npx cache
	clear                         removes empty directories in the npx cache

Parameters:
	uninstall [names]  names of packages to remove (* means all)

Options:
  -d|--dry-run  only print what would be done instead of doing it
  -f|--force    do not report an error if a package is mising
  -v|--verbose  print extra information about the packages and the cache
  -V|--version  print the version of the executable and exits
  -h|--help     print the usage information and exits

Examples:
  $ npxcc ls
  $ npxcc un npx-cache-control'

struct Opts {
	dry_run bool
	force   bool
	verbose bool
}

fn main() {
	run() or {
		eprintln(err.msg())
		exit(1)
	}
}

fn run() ! {
	opts, args := parse[Opts](usage, Input{ version: version })!

	if args.len == 0 {
		println(usage)
		exit(0)
	}

	command := args[0]
	match command {
		'clear' {
			clear(opts.verbose)!
		}
		'ls', 'list' {
			list(opts.verbose)!
		}
		'purge', 'rm', 'remove', 'un', 'uninstall' {
			if args.len == 1 {
				return error('package names are missing')
			}
			purge(args[1..], opts.dry_run, opts.force, opts.verbose)!
		}
		else {
			return error('invalid command "${command}"')
		}
	}
}
