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
  execSync(`docker tag tronquickstart trontools/quickstart:${ver}`)

  console.log(`Pushing to the Docker Hub\n`)
  const push = spawn(`docker push trontools/quickstart:${ver}`, [])

  push.stdout.on('data', function (data) {
    process.stdout.write(data.toString())
  })

  push.stderr.on('data', function (data) {
    console.log('stderr: ' + data.toString())
  })

  push.on('exit', function (code) {

    console.log(`Image successfully pushed.\n`)
  })
})

