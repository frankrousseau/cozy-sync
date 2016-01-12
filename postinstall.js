#!/usr/bin/env node

var spawn = require('child_process').spawn;
var major = process.versions.node.split('.')[0];
var time = 'time@0.11.4';

if (major === '0') {
  time = 'time@0.11.0';
}
spawn('npm', ['install', time], { stdio: 'inherit' });
