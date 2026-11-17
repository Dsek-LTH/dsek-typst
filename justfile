set default-list := true
set quiet

template_documentation := "docs/templates-docs.typ"
example_directory := "examples"
examples := "examples/src/*.typ"
font_directory := "fonts"
source_directory := "src"

# Build all files and run all tests
test: compile-source-files build-examples build-documentation

# Build all examples
build-examples:
    for file in {{examples}}; do just build-example "$file"; done

# Make sure all source files compile
compile-source-files:
    find {{source_directory}} \
        -name '*.typ' \
        -exec just compile-source-file {} \;

# Build the documentation
build-documentation:
    echo 'Building the {{template_documentation}} documentation...'
    just compile '{{template_documentation}}'

[private]
build-example example:
    echo 'Building the {{file_stem(example)}} example...'
    just compile '{{example}}' '{{example_directory / file_stem(example)}}'.pdf

[private]
compile-source-file file:
    echo 'Compiling {{file}}...'
    just compile '{{file}}' -

[private]
compile input output='':
    typst compile \
        --root . \
        --font-path '{{font_directory}}' \
        '{{input}}' {{output}} \
        > /dev/null
