default:
    just --list

watch:
    cargo watch -x check -x test -x run

expand *ARGS:
    cargo +nightly expand {{ARGS}}

audit:
    cargo audit

