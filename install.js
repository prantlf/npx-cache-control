import { dirname, join } from 'path'
import { fileURLToPath } from 'url'
import grab from 'grab-github-release'
import { installLink } from 'link-bin-executable'

const __dirname = dirname(fileURLToPath(import.meta.url))

const repository = 'prantlf/npx-cache-control'
const platformSuffixes = {
  linux: 'linux',
  darwin: 'macos',
  win32: 'windows'
}

try {
  let executable, version
  try {
    ({ executable, version } = await grab({
      repository, platformSuffixes, targetDirectory: __dirname, unpackExecutable: true, verbose: true
    }))
    console.log('downloaded and unpacked "%s" version %s', executable, version)
  } catch (err) {
    console.warn(err)
  }

  if (!executable) {
    executable = join(__dirname, 'npxcc')
    if (process.platform === 'win32') executable += '.exe'
  }
  await installLink({ linkNames: ['npx-cache-control', 'npxcc'], executable, packageDirectory: __dirname, verbose: true })
} catch (err) {
  console.error(err)
  process.exitCode = 1
}
