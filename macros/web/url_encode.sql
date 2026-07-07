{% macro url_encode(string_to_encode) -%}
    {{ return(adapter.dispatch('url_encode', 'dbt_utils')(string_to_encode)) }}
{% endmacro %}

{% macro default__url_encode(string_to_encode) -%}
    
    {%- set url_characters_encodings = 
        [
            ['%', '%25', 37],
            [':', '%3A', 58],
            ['/', '%2F', 47],
            ['?', '%3F', 63],
            ['#', '%23', 35],
            ['[', '%5B', 91],
            [']', '%5D', 93],
            ['@', '%40', 64],
            ['!', '%21', 33],
            ['$', '%24', 36],
            ['&', '%26', 38],
            ['single quote', '%27', 39],
            ['(', '%28', 40],
            [')', '%29', 41],
            ['*', '%2A', 42],
            ['+', '%2B', 43],
            [',', '%2C', 44],   
            [';', '%3B', 59],
            ['=', '%3D', 61],
            [' ', '%20', 32]
        ]
    -%}

    {%- set ns = namespace(returning_query = string_to_encode) -%}

    {%- for character, encoding, decimal_code in url_characters_encodings -%}

        {%- set ns.returning_query = "replace(" ~ ns.returning_query ~ ", chr(" ~ decimal_code ~ "), '" ~ encoding ~ "')" -%}

    {%- endfor -%}

    {{- ns.returning_query -}}
    
{% endmacro %}