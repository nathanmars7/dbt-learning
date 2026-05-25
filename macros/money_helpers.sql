{% macro round_money(column_name) %}
    round({{ column_name }}, 2)
{% endmacro %}


{% macro safe_divide(numerator, denominator) %}
    case
        when {{ denominator }} = 0 then null
        else round({{ numerator }} / {{ denominator }}, 2)
    end
{% endmacro %}