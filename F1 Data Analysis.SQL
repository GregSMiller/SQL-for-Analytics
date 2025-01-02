--Finding the Fastest Driver (Most Points):
WITH driver_points AS (
    SELECT 
        d.driver_id,
        d.driver_name,
        c.constructor_name,
        SUM(r.points) as total_points,
        COUNT(DISTINCT CASE WHEN r.position = 1 THEN race_id END) as wins,
        COUNT(DISTINCT CASE WHEN r.position <= 3 THEN race_id END) as podiums
    FROM f1_race_results r
    JOIN f1_drivers d ON r.driver_id = d.driver_id
    JOIN f1_constructors c ON d.constructor_id = c.constructor_id
    GROUP BY d.driver_id, d.driver_name, c.constructor_name
)

SELECT 
    driver_name,
    constructor_name,
    total_points,
    wins,
    podiums,
    ROUND(total_points / (SELECT COUNT(DISTINCT race_id) FROM f1_races), 2) as avg_points_per_race
FROM driver_points
ORDER BY total_points DESC;



--Finding the Fastest Track:
WITH race_times AS (
    SELECT 
        c.circuit_id,
        c.circuit_name,
        c.length::float as track_length,
        q.race_id,
        q.q3_time::float as lap_time,
        ROW_NUMBER() OVER (PARTITION BY q.race_id, c.circuit_id ORDER BY q.q3_time::float) as position
    FROM f1_qualifying q
    JOIN f1_races r ON q.race_id = r.race_id
    JOIN f1_circuits c ON r.circuit_id = c.circuit_id
    WHERE q.q3_time IS NOT NULL
)
SELECT 
    circuit_name,
    track_length,
    ROUND(AVG(lap_time), 3) as avg_top5_time,
    ROUND((track_length / AVG(lap_time) * 3600), 2) as avg_speed_kph,
    COUNT(DISTINCT race_id) as races_counted
FROM race_times
WHERE position <= 5
GROUP BY circuit_id, circuit_name, track_length
ORDER BY avg_speed_kph DESC;



--Finding the Fastest Constructor (Most Points):
WITH constructor_stats AS (
    SELECT 
        c.constructor_id,
        c.constructor_name,
        SUM(r.points) as total_points,
        COUNT(DISTINCT CASE WHEN r.position = 1 THEN r.race_id END) as wins,
        COUNT(DISTINCT CASE WHEN r.position <= 3 THEN r.race_id END) as podiums,
        COUNT(DISTINCT r.race_id) as races_entered,
        COUNT(DISTINCT CASE WHEN r.status = 'Finished' THEN r.race_id END) as races_finished
    FROM f1_race_results r
    JOIN f1_drivers d ON r.driver_id = d.driver_id
    JOIN f1_constructors c ON d.constructor_id = c.constructor_id
    GROUP BY c.constructor_id, c.constructor_name
)
SELECT 
    constructor_name,
    total_points,
    wins,
    podiums,
    ROUND(total_points::float / races_entered, 2) as avg_points_per_race,
    ROUND((races_finished::float / races_entered * 100), 2) as reliability_percentage
FROM constructor_stats
ORDER BY total_points DESC;
