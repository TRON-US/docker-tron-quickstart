#!/usr/bin/env node

const {execSync, spawn} = require('child_process')
const fs = require('fs')
const path = require('path')

execSync('(cd app && npm version patch)')

let ver = require('../app/package.json').version
const readmePath = path.resolve(__dirname, '../README.md')

let readme = fs.readFileSync(readmePath, 'utf-8')
readme = readme.replace(/### Latest version is `[\d\.]+`/, "### Latest version is `" + ver + "`")

fs.writeFileSync(readmePath, readme)

const build = spawn('utils/build.sh', [])

build.stdout.on('data', function (data) {
  process.stdout.write(data.toString())
})

build.stderr.on('data', function (data) {
  console.log('stderr: ' + data.toString())
})

build.on('exit', function (code) {

  console.log(`Tagging new version ${ver}\n`)
  execSync(`utils/tag.sh ${ver}`)

  ver = ver.split('.')
  const prev = `${ver[0]}.${ver[1]}.${parseInt(ver[2]) - 1}`

  console.log(`Deleting previous ${prev} version locally\n`)
  execSync(`docker rmi ${prev}`)

  console.log('Ready for pushing. Launch:\ndocker push trontools/quickstart\n')
})

