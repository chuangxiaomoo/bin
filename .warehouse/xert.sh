PS8="eval echo \${BASH_SOURCE##*/}\|\$LINENO\|: "
xert() { [ "${1}" -eq 0 ] || echo ${@:2}; return ${1}; }

