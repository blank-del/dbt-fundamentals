{% macro template_example() %}
    {% set expr %}
        select true as bool
    {% endset %}
    {% if execute %}
        {% set results = run_query(expr).columns[0].values()[0] %}
        {{ log('SQL results ' ~ results ,info=True) }}
        select {{ results }} as res
    {% endif %}
{% endmacro %}