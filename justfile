default:
    just --list

# turns on source change detection
watch:
    cargo watch -x check -x test -x run

# expand macros to see what is going on
expand *ARGS:
    cargo +nightly expand {{ARGS}}

# scan dependencies for security vunerabilities
audit:
    cargo audit

# measure test coverage
coverage:
    cargo tarpaulin --ignore-tests

test:
    cargo test
