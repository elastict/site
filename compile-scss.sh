#!/usr/bin/env bash
cd "${0%/*}"

sass scss/base.scss static/css/base.css $@
