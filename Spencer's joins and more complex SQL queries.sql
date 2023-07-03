-- all of my joins and more complex queries

SELECT * FROM hhblock
LEFT JOIN tariffs ON hhblock.day = tariffs.TariffDateTime;

/* write a select query to get a table with the info from the tariffs tabe, 
the hhblock table, and the informations_households table all together in one big table
that I can use to create my data visualizations with */
-- SELECT * FROM ;

SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid;

SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE Acorn_grouped = "Affluent";

SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE Acorn_grouped = "Comfortable";

SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE Acorn_grouped = "Adversity";

SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE Acorn_grouped = "ACORN-U";

SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE Acorn_grouped = "ACORN-";

SELECT max(energy_max), avg(energy_max), stddev(energy_max) FROM daily_dataset
WHERE day BETWEEN '2013-01-01' AND '2013-12-31';

SELECT * FROM daily_dataset
WHERE day BETWEEN '2013-01-01' AND '2013-12-31' AND energy_max > 4.8;

/* This query returns the max, mean, & standard deviation of max daily electricity usage 
and the man, mean, & standard deviation of the sum of daily electricity usage for all 
the houses in the treatment group. */
SELECT max(energy_max), AVG(energy_max), stddev(energy_max), max(energy_sum), AVG(energy_sum), stddev(energy_sum) FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE informations_households.stdorToU = "ToU";


SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE informations_households.stdorToU = "ToU";

SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31' AND informations_households.stdorToU = 'ToU';

SELECT max(energy_max), AVG(energy_max), stddev(energy_max), max(energy_sum), AVG(energy_sum), stddev(energy_sum) FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31' AND informations_households.stdorToU = 'ToU';


-- CREATE TABLE daily_dataset_household_info_ToU
SELECT * FROM daily_dataset 
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE informations_households.stdorToU = "ToU" AND energy_sum IS NOT NULL
ORDER BY energy_sum
LIMIT 353014;

/* write a select query to return the median of the energy_sum column 
in the left join of the daily_dataset and informations_households tables
with only the time of use households */



SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE informations_households.stdorToU = "Std" AND energy_sum IS NOT NULL
ORDER BY energy_sum;

-- find a query where I can find the median of the energy_sum column in the results easily
SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE informations_households.stdorToU = "Std" AND energy_sum IS NOT NULL
ORDER BY energy_sum
LIMIT 1402189;


SELECT max(energy_max), AVG(energy_max), stddev(energy_max), max(energy_sum), AVG(energy_sum), stddev(energy_sum) FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31' AND informations_households.stdorToU = 'Std';

SELECT * FROM daily_dataset
LEFT JOIN informations_households ON daily_dataset.LCLid = informations_households.LCLid
WHERE day BETWEEN '2013-01-01' AND '2013-12-31' AND informations_households.stdorToU = 'Std';



SELECT * FROM hhblock
LEFT JOIN informations_households ON hhblock.LCLid = informations_households.LCLid;


select hh1.day, hh2.numbSmMtrs, hh_0, hh_1, hh_2, hh_3, hh_4, hh_5, hh_6, hh_7, hh_8, hh_9, hh_10, hh_11, hh_12, hh_13, hh_14, hh_15, hh_16, hh_17, hh_18, hh_19, hh_20, hh_21, hh_22, hh_23, hh_24, hh_25, hh_26, hh_27, hh_28, hh_29, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38, hh_39, hh_40, hh_41, hh_42, hh_43, hh_44, hh_45, hh_46, hh_47
from (select day, round(sum(hh_0),1) as hh_0, round(sum(hh_1),1) as hh_1,  round(sum(hh_2),1) as hh_2,  round(sum(hh_3),1) as hh_3,  round(sum(hh_4),1) as hh_4,  round(sum(hh_5),1) as hh_5,  round(sum(hh_6),1) as hh_6,  round(sum(hh_7),1) as hh_7,  round(sum(hh_8),1) as hh_8,  round(sum(hh_9),1) as hh_9,  round(sum(hh_10),1) as hh_10,  round(sum(hh_11),1) as hh_11,  round(sum(hh_12),1) as hh_12,  round(sum(hh_13),1) as hh_13, round(sum(hh_14),1) as hh_14,  round(sum(hh_15),1) as hh_15,  round(sum(hh_16),1) as hh_16,  round(sum(hh_17),1) as hh_17,  round(sum(hh_18),1) as hh_18,  round(sum(hh_19),1) as hh_19,  round(sum(hh_20),1) as hh_20,  round(sum(hh_21),1) as hh_21,  round(sum(hh_22),1) as hh_22,  round(sum(hh_23),1) as hh_23,  round(sum(hh_24),1) as hh_24,  round(sum(hh_25),1) as hh_25,  round(sum(hh_26),1) as hh_26,  round(sum(hh_27),1) as hh_27,  round(sum(hh_28),1) as hh_28,  round(sum(hh_29),1) as hh_29,  round(sum(hh_30),1) as hh_30,  round(sum(hh_31),1) as hh_31,  round(sum(hh_32),1) as hh_32,  round(sum(hh_33),1) as hh_33,  round(sum(hh_34),1) as hh_34,  round(sum(hh_35),1) as hh_35,  round(sum(hh_36),1) as hh_36,  round(sum(hh_37),1) as hh_37,  round(sum(hh_38),1) as hh_38,  round(sum(hh_39),1) as hh_39,  round(sum(hh_40),1) as hh_40,  round(sum(hh_41),1) as hh_41,  round(sum(hh_42),1) as hh_42,  round(sum(hh_43),1) as hh_43,  round(sum(hh_44),1) as hh_44,  round(sum(hh_45),1) as hh_45,  round(sum(hh_46),1) as hh_46,  round(sum(hh_47),1) as hh_47
    from hhblock
    group by day) as hh1
left outer join
(select day, count(distinct LCLid) as numbSmMtrs
    from hhblock
    group by day) as hh2
on hh1.day = hh2.day;


-- write a query that returns the average energy usage overall per half hour period per day
select LCLid, hh1.day, hh2.numbSmMtrs, hh_0/numbSmMtrs as mean_hh0, hh_1/numbSmMtrs as mean_hh1, hh_2/numbSmMtrs as mean_hh2, hh_3/numbSmMtrs as mean_hh3, hh_4/numbSmMtrs as mean_hh4, hh_5/numbSmMtrs as mean_hh5, hh_6/numbSmMtrs as mean_hh6, hh_7/numbSmMtrs as mean_hh7, hh_8/numbSmMtrs as mean_hh8, hh_9/numbSmMtrs as mean_hh9, hh_10/numbSmMtrs as mean_hh10, hh_11/numbSmMtrs as mean_hh11, hh_12/numbSmMtrs as mean_hh12, hh_13/numbSmMtrs as mean_hh13, hh_14/numbSmMtrs as mean_hh14, hh_15/numbSmMtrs as mean_hh15, hh_16/numbSmMtrs as mean_hh16, hh_17/numbSmMtrs as mean_hh17, hh_18/numbSmMtrs as mean_hh18, hh_19/numbSmMtrs as mean_hh19, hh_20/numbSmMtrs as mean_hh20, hh_21/numbSmMtrs as mean_hh21, hh_22/numbSmMtrs as mean_hh22, hh_23/numbSmMtrs as mean_hh23, hh_24/numbSmMtrs as mean_hh24, hh_25/numbSmMtrs as mean_hh25, hh_26/numbSmMtrs as mean_hh26, hh_27/numbSmMtrs as mean_hh27, hh_28/numbSmMtrs as mean_hh28, hh_29/numbSmMtrs as mean_hh29, hh_30/numbSmMtrs as mean_hh30, hh_31/numbSmMtrs as mean_hh31, hh_32/numbSmMtrs as mean_hh32, hh_33/numbSmMtrs as mean_hh33, hh_34/numbSmMtrs as mean_hh34, hh_35/numbSmMtrs as mean_hh35, hh_36/numbSmMtrs as mean_hh36, hh_37/numbSmMtrs as mean_hh37, hh_38/numbSmMtrs as mean_hh38, hh_39/numbSmMtrs as mean_hh39, hh_40/numbSmMtrs as mean_hh40, hh_41/numbSmMtrs as mean_hh41, hh_42/numbSmMtrs as mean_hh42, hh_43/numbSmMtrs as mean_hh43, hh_44/numbSmMtrs as mean_hh44, hh_45/numbSmMtrs as mean_hh45, hh_46/numbSmMtrs as mean_hh46, hh_47/numbSmMtrs as mean_hh47
from (select LCLid, day, round(sum(hh_0),1) as hh_0, round(sum(hh_1),1) as hh_1,  round(sum(hh_2),1) as hh_2,  round(sum(hh_3),1) as hh_3,  round(sum(hh_4),1) as hh_4,  round(sum(hh_5),1) as hh_5,  round(sum(hh_6),1) as hh_6,  round(sum(hh_7),1) as hh_7,  round(sum(hh_8),1) as hh_8,  round(sum(hh_9),1) as hh_9,  round(sum(hh_10),1) as hh_10,  round(sum(hh_11),1) as hh_11,  round(sum(hh_12),1) as hh_12,  round(sum(hh_13),1) as hh_13, round(sum(hh_14),1) as hh_14,  round(sum(hh_15),1) as hh_15,  round(sum(hh_16),1) as hh_16,  round(sum(hh_17),1) as hh_17,  round(sum(hh_18),1) as hh_18,  round(sum(hh_19),1) as hh_19,  round(sum(hh_20),1) as hh_20,  round(sum(hh_21),1) as hh_21,  round(sum(hh_22),1) as hh_22,  round(sum(hh_23),1) as hh_23,  round(sum(hh_24),1) as hh_24,  round(sum(hh_25),1) as hh_25,  round(sum(hh_26),1) as hh_26,  round(sum(hh_27),1) as hh_27,  round(sum(hh_28),1) as hh_28,  round(sum(hh_29),1) as hh_29,  round(sum(hh_30),1) as hh_30,  round(sum(hh_31),1) as hh_31,  round(sum(hh_32),1) as hh_32,  round(sum(hh_33),1) as hh_33,  round(sum(hh_34),1) as hh_34,  round(sum(hh_35),1) as hh_35,  round(sum(hh_36),1) as hh_36,  round(sum(hh_37),1) as hh_37,  round(sum(hh_38),1) as hh_38,  round(sum(hh_39),1) as hh_39,  round(sum(hh_40),1) as hh_40,  round(sum(hh_41),1) as hh_41,  round(sum(hh_42),1) as hh_42,  round(sum(hh_43),1) as hh_43,  round(sum(hh_44),1) as hh_44,  round(sum(hh_45),1) as hh_45,  round(sum(hh_46),1) as hh_46,  round(sum(hh_47),1) as hh_47
    from hhblock
    group by day) as hh1
left outer join
(select day, count(distinct LCLid) as numbSmMtrs
    from hhblock
    group by day) as hh2
on hh1.day = hh2.day;


drop table if exists daily_hh_means;
create table daily_hh_means
select hh1.day, hh2.numbSmMtrs, hh_0/numbSmMtrs as mean_hh0, hh_1/numbSmMtrs as mean_hh1, hh_2/numbSmMtrs as mean_hh2, hh_3/numbSmMtrs as mean_hh3, hh_4/numbSmMtrs as mean_hh4, hh_5/numbSmMtrs as mean_hh5, hh_6/numbSmMtrs as mean_hh6, hh_7/numbSmMtrs as mean_hh7, hh_8/numbSmMtrs as mean_hh8, hh_9/numbSmMtrs as mean_hh9, hh_10/numbSmMtrs as mean_hh10, hh_11/numbSmMtrs as mean_hh11, hh_12/numbSmMtrs as mean_hh12, hh_13/numbSmMtrs as mean_hh13, hh_14/numbSmMtrs as mean_hh14, hh_15/numbSmMtrs as mean_hh15, hh_16/numbSmMtrs as mean_hh16, hh_17/numbSmMtrs as mean_hh17, hh_18/numbSmMtrs as mean_hh18, hh_19/numbSmMtrs as mean_hh19, hh_20/numbSmMtrs as mean_hh20, hh_21/numbSmMtrs as mean_hh21, hh_22/numbSmMtrs as mean_hh22, hh_23/numbSmMtrs as mean_hh23, hh_24/numbSmMtrs as mean_hh24, hh_25/numbSmMtrs as mean_hh25, hh_26/numbSmMtrs as mean_hh26, hh_27/numbSmMtrs as mean_hh27, hh_28/numbSmMtrs as mean_hh28, hh_29/numbSmMtrs as mean_hh29, hh_30/numbSmMtrs as mean_hh30, hh_31/numbSmMtrs as mean_hh31, hh_32/numbSmMtrs as mean_hh32, hh_33/numbSmMtrs as mean_hh33, hh_34/numbSmMtrs as mean_hh34, hh_35/numbSmMtrs as mean_hh35, hh_36/numbSmMtrs as mean_hh36, hh_37/numbSmMtrs as mean_hh37, hh_38/numbSmMtrs as mean_hh38, hh_39/numbSmMtrs as mean_hh39, hh_40/numbSmMtrs as mean_hh40, hh_41/numbSmMtrs as mean_hh41, hh_42/numbSmMtrs as mean_hh42, hh_43/numbSmMtrs as mean_hh43, hh_44/numbSmMtrs as mean_hh44, hh_45/numbSmMtrs as mean_hh45, hh_46/numbSmMtrs as mean_hh46, hh_47/numbSmMtrs as mean_hh47
from (select day, round(sum(hh_0),1) as hh_0, round(sum(hh_1),1) as hh_1,  round(sum(hh_2),1) as hh_2,  round(sum(hh_3),1) as hh_3,  round(sum(hh_4),1) as hh_4,  round(sum(hh_5),1) as hh_5,  round(sum(hh_6),1) as hh_6,  round(sum(hh_7),1) as hh_7,  round(sum(hh_8),1) as hh_8,  round(sum(hh_9),1) as hh_9,  round(sum(hh_10),1) as hh_10,  round(sum(hh_11),1) as hh_11,  round(sum(hh_12),1) as hh_12,  round(sum(hh_13),1) as hh_13, round(sum(hh_14),1) as hh_14,  round(sum(hh_15),1) as hh_15,  round(sum(hh_16),1) as hh_16,  round(sum(hh_17),1) as hh_17,  round(sum(hh_18),1) as hh_18,  round(sum(hh_19),1) as hh_19,  round(sum(hh_20),1) as hh_20,  round(sum(hh_21),1) as hh_21,  round(sum(hh_22),1) as hh_22,  round(sum(hh_23),1) as hh_23,  round(sum(hh_24),1) as hh_24,  round(sum(hh_25),1) as hh_25,  round(sum(hh_26),1) as hh_26,  round(sum(hh_27),1) as hh_27,  round(sum(hh_28),1) as hh_28,  round(sum(hh_29),1) as hh_29,  round(sum(hh_30),1) as hh_30,  round(sum(hh_31),1) as hh_31,  round(sum(hh_32),1) as hh_32,  round(sum(hh_33),1) as hh_33,  round(sum(hh_34),1) as hh_34,  round(sum(hh_35),1) as hh_35,  round(sum(hh_36),1) as hh_36,  round(sum(hh_37),1) as hh_37,  round(sum(hh_38),1) as hh_38,  round(sum(hh_39),1) as hh_39,  round(sum(hh_40),1) as hh_40,  round(sum(hh_41),1) as hh_41,  round(sum(hh_42),1) as hh_42,  round(sum(hh_43),1) as hh_43,  round(sum(hh_44),1) as hh_44,  round(sum(hh_45),1) as hh_45,  round(sum(hh_46),1) as hh_46,  round(sum(hh_47),1) as hh_47
    from hhblock
    group by day) as hh1
left outer join
(select day, count(distinct LCLid) as numbSmMtrs
    from hhblock
    group by day) as hh2
on hh1.day = hh2.day
where hh1.day between '2013-01-01' and '2013-12-31';


drop table if exists daily_hh_means;
create table daily_hh_means
select hh1.day, hh2.numbSmMtrs, round(hh_0/numbSmMtrs,3) as mean_hh0, round(hh_1/numbSmMtrs,3) as mean_hh1, round(hh_2/numbSmMtrs,3) as mean_hh2, round(hh_3/numbSmMtrs,3) as mean_hh3, round(hh_4/numbSmMtrs,3) as mean_hh4, round(hh_5/numbSmMtrs,3) as mean_hh5, round(hh_6/numbSmMtrs,3) as mean_hh6, round(hh_7/numbSmMtrs,3) as mean_hh7, round(hh_8/numbSmMtrs,3) as mean_hh8, round(hh_9/numbSmMtrs,3) as mean_hh9, round(hh_10/numbSmMtrs,3) as mean_hh10, round(hh_11/numbSmMtrs,3) as mean_hh11, round(hh_12/numbSmMtrs,3) as mean_hh12, round(hh_13/numbSmMtrs,3) as mean_hh13, round(hh_14/numbSmMtrs,3) as mean_hh14, round(hh_15/numbSmMtrs,3) as mean_hh15, round(hh_16/numbSmMtrs,3) as mean_hh16, round(hh_17/numbSmMtrs,3) as mean_hh17, round(hh_18/numbSmMtrs,3) as mean_hh18, round(hh_19/numbSmMtrs,3) as mean_hh19, round(hh_20/numbSmMtrs,3) as mean_hh20, round(hh_21/numbSmMtrs,3) as mean_hh21, round(hh_22/numbSmMtrs,3) as mean_hh22, round(hh_23/numbSmMtrs,3) as mean_hh23, round(hh_24/numbSmMtrs,3) as mean_hh24, round(hh_25/numbSmMtrs,3) as mean_hh25, round(hh_26/numbSmMtrs,3) as mean_hh26, round(hh_27/numbSmMtrs,3) as mean_hh27, round(hh_28/numbSmMtrs,3) as mean_hh28, round(hh_29/numbSmMtrs,3) as mean_hh29, round(hh_30/numbSmMtrs,3) as mean_hh30, round(hh_31/numbSmMtrs,3) as mean_hh31, round(hh_32/numbSmMtrs,3) as mean_hh32, round(hh_33/numbSmMtrs,3) as mean_hh33, round(hh_34/numbSmMtrs,3) as mean_hh34, round(hh_35/numbSmMtrs,3) as mean_hh35, round(hh_36/numbSmMtrs,3) as mean_hh36, round(hh_37/numbSmMtrs,3) as mean_hh37, round(hh_38/numbSmMtrs,3) as mean_hh38, round(hh_39/numbSmMtrs,3) as mean_hh39, round(hh_40/numbSmMtrs,3) as mean_hh40, round(hh_41/numbSmMtrs,3) as mean_hh41, round(hh_42/numbSmMtrs,3) as mean_hh42, round(hh_43/numbSmMtrs,3) as mean_hh43, round(hh_44/numbSmMtrs,3) as mean_hh44, round(hh_45/numbSmMtrs,3) as mean_hh45, round(hh_46/numbSmMtrs,3) as mean_hh46, round(hh_47/numbSmMtrs,3) as mean_hh47
from (select day, sum(hh_0) as hh_0, sum(hh_1) as hh_1,  sum(hh_2) as hh_2,  sum(hh_3) as hh_3,  sum(hh_4) as hh_4,  sum(hh_5) as hh_5,  sum(hh_6) as hh_6,  sum(hh_7) as hh_7,  sum(hh_8) as hh_8,  sum(hh_9) as hh_9,  sum(hh_10) as hh_10,  sum(hh_11) as hh_11,  sum(hh_12) as hh_12,  sum(hh_13) as hh_13, sum(hh_14) as hh_14, sum(hh_15) as hh_15, sum(hh_16) as hh_16,  sum(hh_17) as hh_17, sum(hh_18) as hh_18, sum(hh_19) as hh_19, sum(hh_20) as hh_20,  sum(hh_21) as hh_21, sum(hh_22) as hh_22, sum(hh_23) as hh_23, sum(hh_24) as hh_24, sum(hh_25) as hh_25, sum(hh_26) as hh_26, sum(hh_27) as hh_27, sum(hh_28) as hh_28, sum(hh_29) as hh_29, sum(hh_30) as hh_30, sum(hh_31) as hh_31, sum(hh_32) as hh_32, sum(hh_33) as hh_33, sum(hh_34) as hh_34, sum(hh_35) as hh_35, sum(hh_36) as hh_36, sum(hh_37) as hh_37, sum(hh_38) as hh_38, sum(hh_39) as hh_39, sum(hh_40) as hh_40, sum(hh_41) as hh_41, sum(hh_42) as hh_42, sum(hh_43) as hh_43, sum(hh_44) as hh_44, sum(hh_45) as hh_45, sum(hh_46) as hh_46, sum(hh_47) as hh_47
    from hhblock
    group by day) as hh1
left outer join (select day, count(distinct LCLid) as numbSmMtrs
    from hhblock
    group by day) as hh2 on hh1.day = hh2.day
where hh1.day between '2013-01-01' and '2013-12-31';


SELECT * FROM daily_hh_averages;

SELECT * FROM daily_hh_means;
SELECT * FROM daily_hh_means
LEFT OUTER JOIN tariffs ON daily_hh_means.day = tariffs.TariffDateTime;


SELECT * FROM tariffs
LEFT OUTER JOIN daily_hh_means ON tariffs.TariffDateTime = daily_hh_means.day;