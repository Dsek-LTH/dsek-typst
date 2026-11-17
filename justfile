set default-list := true
set quiet

template_documentation := "docs/templates-docs.typ"
example_directory := "examples"
examples := "examples/src/*.typ"
font_directory := "fonts"
source_directory := "src"

# Bless the output of some (or all) tests
bless *tests:
    tt update \
        --font-path '{{font_directory}}' \
        -- {{tests}}

# Build all examples
build-examples:
    #!/bin/sh
    set -e

    for file in {{examples}}; do
        just build-example "$file"
    done

# Cleans non-tracked output
clean:
    tt util clean

# Make sure all source files compile
compile-source-files:
    #!/bin/sh
    set -e

    for file in $(find {{source_directory}} -name '*.typ'); do
        just compile-source-file "$file"
    done

# Build the documentation
build-documentation:
    echo 'Building the {{template_documentation}} documentation...'
    just compile '{{template_documentation}}'

# Installs the fonts locally for the current user
install-fonts:
    fonts/install

# Build all files and run all tests
test: compile-source-files build-examples build-documentation tytanic

# Run all tytanic tests
tytanic:
    tt run \
        --font-path '{{font_directory}}'

# Uninstalls the fonts as installed by `install-fonts`
uninstall-fonts:
    fonts/install uninstall

# Updates the examples from the tests
update-examples: copy-examples build-examples

[private]
compile input output='':
    typst compile \
        --root . \
        --font-path '{{font_directory}}' \
        '{{input}}' {{output}} \
        > /dev/null

[private]
copy-examples:
    #!/bin/sh
    set -e

    package_version=$(sed -n 's|^version = "\(.*\)"$|\1|p' typst.toml)

    for test in tests/examples/*/; do
        sed "s|/src/lib.typ|@preview/dsek:$package_version|g" \
            "$test/test.typ" \
            > "examples/src/$(basename "$test").typ"
    done

[private]
compile-source-file file:
    echo 'Compiling {{file}}...'
    just compile '{{file}}' -

[private]
build-example example:
    echo 'Building the {{file_stem(example)}} example...'
    just compile '{{example}}' '{{example_directory / file_stem(example)}}'.pdf
