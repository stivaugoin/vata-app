CREATE OR REPLACE FUNCTION get_individual_id(key text) RETURNS uuid AS $$
    BEGIN
        RETURN CASE key
            /* Generation 4 */
            WHEN 'fleamont_potter' THEN     '00000001-0004-0000-0000-000000000001'::uuid
            WHEN 'euphemia_potter' THEN     '00000001-0004-0000-0000-000000000002'::uuid
            WHEN 'john_evans' THEN          '00000001-0004-0000-0000-000000000003'::uuid
            WHEN 'mary_evans' THEN          '00000001-0004-0000-0000-000000000004'::uuid
            WHEN 'septimus_weasley' THEN    '00000001-0004-0000-0000-000000000005'::uuid
            WHEN 'cedrella_black' THEN      '00000001-0004-0000-0000-000000000006'::uuid
            WHEN 'ignatius_prewett' THEN    '00000001-0004-0000-0000-000000000007'::uuid
            WHEN 'lucretia_prewett' THEN    '00000001-0004-0000-0000-000000000008'::uuid

            /* Generation 3 */
            WHEN 'james_potter' THEN        '00000001-0003-0000-0000-000000000001'::uuid
            WHEN 'lily_evans' THEN          '00000001-0003-0000-0000-000000000002'::uuid
            WHEN 'arthur_weasley' THEN      '00000001-0003-0000-0000-000000000003'::uuid
            WHEN 'molly_prewett' THEN       '00000001-0003-0000-0000-000000000004'::uuid
            WHEN 'william_granger' THEN     '00000001-0003-0000-0000-000000000005'::uuid
            WHEN 'helen_granger' THEN       '00000001-0003-0000-0000-000000000006'::uuid

            /* Generation 2 */
            WHEN 'bill_weasley' THEN        '00000001-0002-0000-0000-000000000001'::uuid
            WHEN 'charlie_weasley' THEN     '00000001-0002-0000-0000-000000000002'::uuid
            WHEN 'percy_weasley' THEN       '00000001-0002-0000-0000-000000000003'::uuid
            WHEN 'fred_weasley' THEN        '00000001-0002-0000-0000-000000000004'::uuid
            WHEN 'george_weasley' THEN      '00000001-0002-0000-0000-000000000005'::uuid
            WHEN 'ron_weasley' THEN         '00000001-0002-0000-0000-000000000006'::uuid
            WHEN 'ginny_weasley' THEN       '00000001-0002-0000-0000-000000000007'::uuid
            WHEN 'harry_potter' THEN        '00000001-0002-0000-0000-000000000008'::uuid
            WHEN 'hermione_granger' THEN    '00000001-0002-0000-0000-000000000009'::uuid

            /* Generation 1 */
            WHEN 'james_sirius_potter' THEN '00000001-0001-0000-0000-000000000001'::uuid
            WHEN 'albus_potter' THEN        '00000001-0001-0000-0000-000000000002'::uuid
            WHEN 'lily_luna_potter' THEN    '00000001-0001-0000-0000-000000000003'::uuid
            WHEN 'rose_weasley' THEN        '00000001-0001-0000-0000-000000000004'::uuid
            WHEN 'hugo_weasley' THEN        '00000001-0001-0000-0000-000000000005'::uuid

            /* Historical Figures */
            WHEN 'tom_riddle' THEN          '00000001-0000-0000-0000-000000000001'::uuid
            WHEN 'godric_gryffindor' THEN   '00000001-0000-0000-0000-000000000002'::uuid
            WHEN 'salazar_slytherin' THEN   '00000001-0000-0000-0000-000000000003'::uuid
            WHEN 'helga_hufflepuff' THEN    '00000001-0000-0000-0000-000000000004'::uuid

            ELSE NULL
        END;
    END;

$$ LANGUAGE plpgsql IMMUTABLE;
