/* Copyright (c) 2017-2019 ARM Limited
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*******************************************************************************
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * THIS FILE IS AN AUTO-GENERATED FILE - DO NOT MODIFY IT.
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * Template Version 1.0
 * Generated by tools/psa/generate_partition_code.py Version {{script_ver}}
 ******************************************************************************/

#ifndef __MBED_SPM_PARTITIONS_H___
#define __MBED_SPM_PARTITIONS_H___

{% macro do_parition(partition) -%}

/* -----------------------------------------------------------------------------
 * {{partition.name|upper}} defines
 * -------------------------------------------------------------------------- */
#define {{partition.name|upper}}_ID {{partition.id}}

{% if partition.rot_services|count > 0 %}
#define {{partition.name|upper}}_ROT_SRV_COUNT ({{partition.rot_services|count}}UL)
{% endif %}
#define {{partition.name|upper}}_EXT_ROT_SRV_COUNT ({{partition.extern_sids|count}}UL)

{% for irq in partition.irqs %}
#define {{irq.signal|upper}}_POS ({{loop.index + 3 }}UL)
#define {{irq.signal|upper}} (1UL << {{irq.signal|upper}}_POS)
{% endfor %}

{% if partition.irqs|count > 0 %}
#define {{partition.name|upper}}_WAIT_ANY_IRQ_MSK (\
{% for irq in partition.irqs %}
    {{irq.signal|upper}}{{")" if loop.last else " | \\"}}
{% endfor %}
{% else %}
#define {{partition.name|upper}}_WAIT_ANY_IRQ_MSK (0)
{% endif %}

{% for rot_srv in partition.rot_services %}
#define {{rot_srv.signal|upper}}_POS ({{loop.index + 3 + partition.irqs|count}}UL)
#define {{rot_srv.signal|upper}} (1UL << {{rot_srv.signal|upper}}_POS)
{% endfor %}

{% if partition.rot_services|count > 0 %}
#define {{partition.name|upper}}_WAIT_ANY_SID_MSK (\
{% for rot_srv in partition.rot_services %}
    {{rot_srv.signal|upper}}{{")" if loop.last else " | \\"}}
{% endfor %}
{% else %}
#define {{partition.name|upper}}_WAIT_ANY_SID_MSK (0)
{% endif %}

{% if partition.irqs|count > 0 %}
uint32_t spm_{{partition.name|lower}}_signal_to_irq_mapper(uint32_t signal);
{% endif %}
{%- endmacro %}
{# ------------------ macro do_parition(partition) -------------------------- #}

/****************** Common definitions ****************************************/

/* PSA reserved event flags */
#define PSA_RESERVED1_POS (1UL)
#define PSA_RESERVED1_MSK (1UL << PSA_RESERVED1_POS)

#define PSA_RESERVED2_POS (2UL)
#define PSA_RESERVED2_MSK (1UL << PSA_RESERVED2_POS)

/****************** Service Partitions ****************************************/

{% for partition in service_partitions %}
{{ do_parition(partition) }}
{% endfor %}

/****************** Test Partitions *******************************************/

#ifdef USE_PSA_TEST_PARTITIONS

{% for test_partition in test_partitions %}
#ifdef USE_{{test_partition.name|upper}}
{{ do_parition(test_partition) }}
#endif  // USE_{{test_partition.name|upper}}

{% endfor %}

#endif  // USE_PSA_TEST_PARTITIONS

#endif // __MBED_SPM_PARTITIONS_H___
{# End of file #}
