#!/usr/bin/env node

const {execSync, spawn} = require('child_process')
const fs = require('fs')
const path = require('path')

execSync('(cd app && npm version patch)')

let ver = require('../app/package.json').version
let fsPath = path.resolve(__dirname, '../README.md')
let readme = fs.readFileSync(fsPath, 'utf-8')
readme = readme.replace(/### Latest version is `[\d\.]+`/, "### Latest version is `" + ver + "`")
fs.writeFileSync(fsPath, readme)

fsPath = path.resolve(__dirname, '../Dockerfile')
let dockerfile = fs.readFileSync(fsPath, 'utf-8')
dockerfile = dockerfile.replace(/"v[0-9\.]+"/, '"v' + ver + '"')
fs.writeFileSync(fsPath, dockerfile)

fsPath = path.resolve(__dirname, '../version')
fs.writeFileSync(fsPath, ver)

const build = spawn('bin/build.sh', [])

build.stdout.on('data', function (data) {
  process.stdout.write(data.toString())
})

build.stderr.on('data', function (data) {
  console.log('stderr: ' + data.toString())
})

build.on('exit', function (code) {

  console.log(`Tagging new version ${ver}\n`)
  execSync(`bin/tag.sh ${ver}`)

  console.log('To push run "bin/push.sh"')
})

