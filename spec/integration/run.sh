#!/bin/sh

cd "$(dirname $0)"
cd ../.. # /path/to/shittp

green() {
  printf "\033[0;92;49m%s\033[0m" "$1" >&2
}

greenln() {
  green "$1"; echo
}

red() {
  printf "\033[0;91;49m%s\033[0m" "$1" >&2
}

redln() {
  red "$1"; echo
}

for_line() {
  while IFS= read -r line; do
    eval "$1 $line"
  done
}

build_image() {
  docker build --tag "${1%%.Dockerfile}:latest" --file "spec/integration/dockerfiles/$1" .
}

report=''
run_spec() {
  docker run --rm "$1" "$2"
  excode=$?
  if [ "$excode" -eq 0 ]; then
    report="$report o"
  else
    report="$report x"
    failed=1
  fi
}

while IFS= read -r line; do
  build_image "$line"
done <<EOF 
shittp-test-base.Dockerfile
shittp-test-bash.Dockerfile
shittp-test-vim.Dockerfile
EOF


while IFS= read -r line; do
  run_spec $line
done <<EOF 
shittp-test-base:latest  spec/basic_spec.tcl
shittp-test-bash:latest  spec/bash_spec.tcl
shittp-test-vim:latest   spec/vim_spec.tcl
EOF

echo
for line in $report; do
  case $line in
    x)
      red "$line"
      ;;
    o)
      green "$line"
      ;;
  esac
done
echo
echo

if [ "${failed:-}" = 1 ]; then
  redln "Integration test failed :("
else
  greenln "Integration test passed :)"
fi
echo
