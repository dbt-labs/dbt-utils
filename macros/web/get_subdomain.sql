{#
Extracts the subdomain from a column containing a url.

Example Usage:

    Input:

    | id | url |
    |------+-------|
    | 6042b8e8c4d3a102247b68d6df31b621 | https://blog.mycompany.com/ |
    | 177fb7a1674bf2f48daecef83d00424e | https://mycompany.com/ |
    | dadc991ccfca3630004a7187fe3e3183 | https://help.mycompany.com/ |
    | 20b0bebfffd6a350ae5015587d7a4cc9 | https://community.mycompany.com/ |

    select
      p.id,
      p.url,
      {{ dbt_utils.get_subdomain(url='p.url', domain='mycompany') }} as subdomain
    from segment.pages p

    Output:

    | id | url | subdomain |
    |------+-----+------|
    | 6042b8e8c4d3a102247b68d6df31b621 | https://blog.mycompany.com/ | blog |
    | 177fb7a1674bf2f48daecef83d00424e | https://mycompany.com/ | NULL |
    | dadc991ccfca3630004a7187fe3e3183 | https://help.mycompany.com/ | help |
    | 20b0bebfffd6a350ae5015587d7a4cc9 | https://community.mycompany.com/ | community |

Arguments:
    url: The name of the column containing the URL.
    domain: The domain name
#}

{% macro get_subdomain(url, domain) -%}

{%- set formatted_domain = "'." + domain + "'" -%}

{%- set split_one = dbt_utils.split_part(string_text=url, delimiter_text="'https://'", part_number=2) -%}

{%- set split_two = dbt_utils.split_part(string_text=split_one, delimiter_text=formatted_domain, part_number=1) -%}

case
  when {{ split_one }} = {{ split_two }} then null
  else {{ split_two }}
end

{%- endmacro %}
