#!/usr/bin/env node

const {spawn} = require('child_process')
let ver = require('../app/package.json').version

const build = spawn(`docker push trontools/quickstart:${ver} && docker push trontools/quickstart:latest`, [])

build.stdout.on('data', function (data) {
  process.stdout.write(data.toString())
})

build.stderr.on('data', function (data) {
  console.log('stderr: ' + data.toString())
})

build.on('exit', function (code) {
  console.log('Pushed.')
})

