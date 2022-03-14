{#  
    -- let's develop a macro that 
    1. queries the information schema of a database
    2. finds objects that are > 1 week old (no longer maintained)
    3. generates automated drop statements
    4. has the ability to execute those drop statements

#}

{% macro clean_stale_models(database=target.database, schema=target.schema, days = 7, dry_run = True) %}
    {% set drop_query %}
        select 
            case 
                when table_type = 'VIEW'
                    then table_type
                else 
                    'TABLE'
            end as drop_type,
            'DROP ' || drop_type || ' {{ database | upper }}.' || table_schema || '.' || table_name || ';'
        from {{ database }}.information_schema.tables
        where table_schema= upper('{{ schema }}')
        and last_altered <= current_date - {{ days }}
    {% endset %}
    {{ log('\nGenerating cleanup queries...\n',info=True) }}
    {% set drop_queries = run_query(drop_query).columns[1].values() %}
    {% for item in drop_queries %}
        {% if dry_run %}
            {{ log(item, info=True) }}
        {% else %}
            {{ log('Dropping object with command: ' ~ item, info=True) }}
            {% do run_query(item) %} 
        {% endif %}
    {% endfor %}
{% endmacro %}