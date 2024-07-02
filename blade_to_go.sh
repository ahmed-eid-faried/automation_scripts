#!/bin/bash
# to run this convertor :-
# chmod +x blade_to_go.sh
# ./blade_to_go.sh testblade

# Function to convert Blade variables to Go template variables
convert_variables() {
    sed -E 's/\{\{\s*(.+?)\s*\}\}/{{ .\1 }}/g'
}

# Function to convert HTML entity encoding
convert_html_entity_encoding() {
    sed -E 's/\{\!!\s*(.+?)\s*!!\}/{{ .\1 | safe }}/g'
}

# Function to convert Blade if statements to Go template if statements
convert_if_statements() {
    sed -E -e 's/@if\s*\((.+?)\)/{{ if \1 }}/g' \
        -e 's/@elseif\s*\((.+?)\)/{{ else if \1 }}/g' \
        -e 's/@else/{{ else }}/g' \
        -e 's/@endif/{{ end }}/g'
}

# Function to convert Blade switch statements to Go template switch statements
convert_switch_statements() {
    sed -E -e 's/@switch\s*\((.+?)\)/{{ switch \1 }}/g' \
        -e 's/@case\s*\((.+?)\)/{{ case \1 }}/g' \
        -e 's/@default/{{ default }}/g' \
        -e 's/@endswitch/{{ end }}/g'
}

# Function to convert Blade loops to Go template loops
convert_loops() {
    sed -E -e 's/@foreach\s*\((\$[^ ]+)\s+as\s+(\$[^ ]+)\)/{{ range \1 }} {{ \2 := . }}/g' \
        -e 's/@endforeach/{{ end }}/g' \
        -e 's/@for\s*\(([^;]+);([^;]+);([^)]+)\)/{{ $1 }} {{ range $2 }} {{ $3 }}/g' \
        -e 's/@endfor/{{ end }}/g' \
        -e 's/@while\s*\((.+?)\)/{{ range \1 }}/g' \
        -e 's/@endwhile/{{ end }}/g'
}

# Function to convert Blade includes to Go template includes
convert_includes() {
    sed -E 's/@include\([[:space:]]*'\''([^'\'']+)'\''[[:space:]]*\)/{{ template "\1.html" . }}/g'
}

# Function to convert Blade sections and yields to Go template sections and yields
convert_sections() {
    sed -E -e 's/@section\([[:space:]]*'\''([^'\'']+)'\''[[:space:]]*\)/{{ define "\1" }}/g' \
        -e 's/@endsection/{{ end }}/g' \
        -e 's/@show/{{ end }}/g' \
        -e 's/@yield\([[:space:]]*'\''([^'\'']+)'\''[[:space:]]*\)/{{ template "\1" . }}/g'
}

# Function to convert conditional classes
convert_conditional_classes() {
    sed -E 's/@class\(([^)]+)\)/{{ if \1 }}/g'
}

# Function to convert additional attributes
convert_additional_attributes() {
    sed -E 's/@attribute\(([^)]+)\)/{{ if \1 }}/g'
}

# Function to convert subviews including
convert_subviews() {
    sed -E 's/@each\(([^,]+),([^,]+),([^,]+)\)/{{ range .\2 }}{{ template "\3" .\1 }}{{ end }}/g'
}

# Function to convert @once directive
convert_once_directive() {
    sed -E -e 's/@once/{{ once }}/g' -e 's/@endonce/{{ endonce }}/g'
}

# Function to convert raw PHP
convert_raw_php() {
    sed -E 's/@php\s*(.+?)\s*@endphp/{{ $1 }}/g'
}

# Function to convert comments
convert_comments() {
    sed -E 's/{{--(.+?)--}}/{{/* \1 */}}/g'
}

# Function to convert custom Blade directives
convert_custom_directives() {
    sed -E 's/@customDirective\(([^)]+)\)/{{ custom \1 }}/g'
}

# Function to convert Blade components
convert_components() {
    sed -E 's/<x-([^ ]+)\s*(.*?)\/>/{{ template "\1.html" . }}/g'
}

# Function to convert Blade component data
convert_component_data() {
    sed -E 's/<x-([^ ]+)\s*:\$([^ ]+)=["'"'"']([^"'"'"']+)["'"'"']\s*\/>/{{ template "\1.html" (dict "data" .\2 "value" .\3) }}/g'
}

# Function to convert Blade slots
convert_slots() {
    sed -E 's/<x-slot\s*:name=["'"'"']([^"'"'"']+)["'"'"']>(.*?)<\/x-slot>/{{ define "\1" }}\2{{ end }}/g'
}

# Function to convert Blade and JavaScript frameworks (no direct conversion needed)
convert_js_frameworks() {
    cat
}

# Function to convert Blade inline components
convert_inline_components() {
    sed -E 's/<x-([^ ]+)\s*(.*?)>(.*?)<\/x-\1>/{{ template "\1.html" . }}\3{{ end }}/g'
}

# Function to convert Blade dynamic components
convert_dynamic_components() {
    sed -E 's/<x-dynamic-component\s*:\:component=["'"'"']([^"'"'"']+)["'"'"']\s*\/>/{{ template "\1.html" . }}/g'
}

# Function to convert Blade layouts
convert_layouts() {
    sed -E 's/@extends\([[:space:]]*'\''([^'\'']+)'\''[[:space:]]*\)/{{ define "\1" }}/g'
}

# Function to convert Blade layout inheritance
convert_layout_inheritance() {
    sed -E 's/@section\([[:space:]]*'\''([^'\'']+)'\''[[:space:]]*\)/{{ block "\1" . }}/g'
}

# Function to convert Blade forms
convert_forms() {
    sed -E 's/<form\s*(.*?)>/{{ "<form \1>" | safe }}/g'
}

# Function to convert CSRF field
convert_csrf_field() {
    sed -E 's/@csrf/{{ csrf_field }}/g'
}

# Function to convert method field
convert_method_field() {
    sed -E 's/@method\(([^)]+)\)/{{ method_field(\1) }}/g'
}

# Function to convert validation errors
convert_validation_errors() {
    sed -E 's/@error\(([^)]+)\)/{{ if .Errors.\1 }}/g' -e 's/@enderror/{{ end }}/g'
}

# Function to convert Blade stacks
convert_stacks() {
    sed -E 's/@stack\(([^)]+)\)/{{ block "\1" . }}/g'
}

# Function to convert service injection
convert_service_injection() {
    sed -E 's/@inject\(([^)]+)\)/{{ inject "\1" . }}/g'
}

# Function to convert inline Blade templates
convert_inline_templates() {
    sed -E 's/@component\(([^)]+)\)/{{ template "\1.html" . }}/g' -e 's/@endcomponent/{{ end }}/g'
}

# Function to convert Blade fragments
convert_blade_fragments() {
    sed -E 's/@fragment\(([^)]+)\)/{{ fragment "\1" . }}/g'
}
# Function to extend Blade
extend_blade() {
    # Placeholder for extending Blade, which requires custom logic
    cat
}

# Function to convert custom echo handlers
convert_custom_echo_handlers() {
    # Placeholder for custom echo handlers
    cat
}

# Function to convert custom if statements
convert_custom_if_statements() {
    # Placeholder for custom if statements
    cat
}

# Function to process the file and apply all conversions
convert_blade_to_go_template() {
    local file_path=$1
    local output_file=$2

    # Read file content
    content=$(cat "$file_path")

    # Apply conversions
    content=$(echo "$content" | convert_variables)
    content=$(echo "$content" | convert_html_entity_encoding)
    content=$(echo "$content" | convert_if_statements)
    content=$(echo "$content" | convert_switch_statements)
    content=$(echo "$content" | convert_loops)
    content=$(echo "$content" | convert_includes)
    content=$(echo "$content" | convert_sections)
    content=$(echo "$content" | convert_conditional_classes)
    content=$(echo "$content" | convert_additional_attributes)
    content=$(echo "$content" | convert_subviews)
    content=$(echo "$content" | convert_once_directive)
    content=$(echo "$content" | convert_raw_php)
    content=$(echo "$content" | convert_comments)
    content=$(echo "$content" | convert_js_frameworks)
    content=$(echo "$content" | convert_custom_directives)
    content=$(echo "$content" | convert_components)
    content=$(echo "$content" | convert_component_data)
    content=$(echo "$content" | convert_slots)
    content=$(echo "$content" | convert_inline_components)
    content=$(echo "$content" | convert_dynamic_components)
    content=$(echo "$content" | convert_layouts)
    content=$(echo "$content" | convert_layout_inheritance)
    content=$(echo "$content" | convert_forms)
    content=$(echo "$content" | convert_csrf_field)
    content=$(echo "$content" | convert_method_field)
    content=$(echo "$content" | convert_validation_errors)
    content=$(echo "$content" | convert_stacks)
    content=$(echo "$content" | convert_service_injection)
    content=$(echo "$content" | convert_inline_templates)
    content=$(echo "$content" | convert_blade_fragments)
    content=$(echo "$content" | extend_blade)
    content=$(echo "$content" | convert_custom_echo_handlers)
    content=$(echo "$content" | convert_custom_if_statements)

    # Write to the output file
    echo "$content" >"$output_file"
}

# Main script execution
if [ $# -lt 1 ]; then
    echo "Usage: $0 path/to/directory"
    exit 1
fi

input_directory=$1

# Check if the input is a directory
if [ ! -d "$input_directory" ]; then
    echo "Error: $input_directory is not a directory"
    exit 1
fi

# Find all Blade PHP files in the directory and its subdirectories
find "$input_directory" -type f -name "*.blade.php" | while read -r blade_file_path; do
    go_template_file_path=$(echo "$blade_file_path" | sed 's/.blade.php/.html/')
    convert_blade_to_go_template "$blade_file_path" "$go_template_file_path"
    echo "Converted Blade template to Go template: $go_template_file_path"
done
