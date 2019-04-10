#!/bin/sh

exec node -i --experimental-repl-await -e "{ var L = require('lodash'); var R = require('ramda'); }";