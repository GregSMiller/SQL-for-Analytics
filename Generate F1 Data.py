import random
from datetime import datetime, timedelta
import pandas as pd
import numpy as np

# Constants
SEASONS = [2022, 2023, 2024]
CONSTRUCTORS = {
    1: "Mercedes",
    2: "Red Bull Racing",
    3: "Ferrari",
    4: "McLaren",
    5: "Aston Martin",
    6: "Alpine",
    7: "AlphaTauri",
    8: "Alfa Romeo",
    9: "Haas F1",
    10: "Williams"
}

DRIVERS = {
    44: ("Lewis Hamilton", 1),
    63: ("George Russell", 1),
    1: ("Max Verstappen", 2),
    11: ("Sergio Perez", 2),
    16: ("Charles Leclerc", 3),
    55: ("Carlos Sainz", 3),
    4: ("Lando Norris", 4),
    81: ("Oscar Piastri", 4),
    14: ("Fernando Alonso", 5),
    18: ("Lance Stroll", 5),
    10: ("Pierre Gasly", 6),
    31: ("Esteban Ocon", 6),
    22: ("Yuki Tsunoda", 7),
    3: ("Daniel Ricciardo", 7),
    77: ("Valtteri Bottas", 8),
    24: ("Zhou Guanyu", 8),
    20: ("Kevin Magnussen", 9),
    27: ("Nico Hulkenberg", 9),
    23: ("Alexander Albon", 10),
    2: ("Logan Sargeant", 10)
}

CIRCUITS = {
    1: ("Bahrain International Circuit", "Bahrain", "5.412"),
    2: ("Jeddah Corniche Circuit", "Saudi Arabia", "6.174"),
    3: ("Albert Park Circuit", "Australia", "5.278"),
    4: ("Baku City Circuit", "Azerbaijan", "6.003"),
    5: ("Miami International Autodrome", "USA", "5.412"),
    6: ("Circuit de Monaco", "Monaco", "3.337"),
    7: ("Circuit de Barcelona-Catalunya", "Spain", "4.675"),
    8: ("Red Bull Ring", "Austria", "4.318"),
    9: ("Silverstone Circuit", "Great Britain", "5.891"),
    10: ("Hungaroring", "Hungary", "4.381"),
    11: ("Circuit de Spa-Francorchamps", "Belgium", "7.004"),
    12: ("Circuit Zandvoort", "Netherlands", "4.259"),
    13: ("Autodromo Nazionale Monza", "Italy", "5.793"),
    14: ("Marina Bay Street Circuit", "Singapore", "5.063"),
    15: ("Suzuka International Racing Course", "Japan", "5.807"),
    16: ("Losail International Circuit", "Qatar", "5.380"),
    17: ("Circuit of the Americas", "USA", "5.513"),
    18: ("Autódromo Hermanos Rodríguez", "Mexico", "4.304"),
    19: ("Interlagos Circuit", "Brazil", "4.309"),
    20: ("Las Vegas Strip Circuit", "USA", "6.120"),
    21: ("Yas Marina Circuit", "Abu Dhabi", "5.281")
}

def generate_race_calendar(season):
    calendar = []
    start_date = datetime(season, 3, 1)  # Season typically starts in March
    
    for circuit_id in CIRCUITS.keys():
        race_date = start_date + timedelta(days=14*circuit_id)  # Roughly 2 weeks between races
        if race_date.year == season:  # Only include races that fall within the season
            calendar.append({
                'race_id': f"{season}{circuit_id:02d}",
                'season': season,
                'circuit_id': circuit_id,
                'race_date': race_date.strftime('%Y-%m-%d')
            })
    return calendar

def generate_qualifying_result(race_id, season):
    drivers = list(DRIVERS.keys())
    random.shuffle(drivers)
    
    results = []
    for position, driver_id in enumerate(drivers, 1):
        base_time = 80.0  # Base lap time in seconds
        variation = random.uniform(-0.5, 0.5)  # Add some randomness
        
        # Top teams tend to be faster
        team_advantage = {1: -0.5, 2: -0.3, 3: -0.2, 4: -0.1}.get(DRIVERS[driver_id][1], 0)
        
        q1_time = base_time + variation + team_advantage + random.uniform(0, 0.3)
        q2_time = base_time + variation + team_advantage + random.uniform(0, 0.2) if position <= 15 else None
        q3_time = base_time + variation + team_advantage + random.uniform(0, 0.1) if position <= 10 else None
        
        results.append({
            'race_id': race_id,
            'driver_id': driver_id,
            'position': position,
            'q1_time': f"{q1_time:.3f}" if q1_time else None,
            'q2_time': f"{q2_time:.3f}" if q2_time else None,
            'q3_time': f"{q3_time:.3f}" if q3_time else None
        })
    return results

def generate_race_result(race_id, season, qualifying_results):
    points_system = {1: 25, 2: 18, 3: 15, 4: 12, 5: 10, 6: 8, 7: 6, 8: 4, 9: 2, 10: 1}
    
    # Start with qualifying order but introduce some changes
    results = []
    quali_order = [(r['driver_id'], r['position']) for r in qualifying_results]
    
    # Simulate some DNFs
    dnf_count = random.randint(0, 3)
    dnfs = random.sample(quali_order, dnf_count)
    
    finished_positions = []
    for driver_id, quali_pos in quali_order:
        if (driver_id, quali_pos) in dnfs:
            position = None
            status = random.choice(['Mechanical', 'Collision', 'Power Unit', 'Hydraulics'])
            points = 0
        else:
            # Calculate new position with some random position changes
            new_pos = quali_pos + random.randint(-5, 5)
            while new_pos in finished_positions or new_pos < 1:
                new_pos = quali_pos + random.randint(-3, 3)
            position = new_pos
            finished_positions.append(new_pos)
            status = 'Finished'
            points = points_system.get(position, 0)
        
        # Random fastest lap point
        fastest_lap = False
        if position and position <= 10 and random.random() < 0.1:
            fastest_lap = True
            points += 1
            
        results.append({
            'race_id': race_id,
            'driver_id': driver_id,
            'position': position,
            'status': status,
            'points': points,
            'fastest_lap': fastest_lap
        })
    
    return sorted(results, key=lambda x: (x['position'] is None, x['position']))

# Generate the complete dataset
races = []
qualifying = []
race_results = []

for season in SEASONS:
    season_races = generate_race_calendar(season)
    races.extend(season_races)
    
    for race in season_races:
        quali_results = generate_qualifying_result(race['race_id'], season)
        qualifying.extend(quali_results)
        
        results = generate_race_result(race['race_id'], season, quali_results)
        race_results.extend(results)

# Convert to DataFrames
races_df = pd.DataFrame(races)
qualifying_df = pd.DataFrame(qualifying)
race_results_df = pd.DataFrame(race_results)

# Create lookup tables
drivers_df = pd.DataFrame([
    {'driver_id': k, 'driver_name': v[0], 'constructor_id': v[1]}
    for k, v in DRIVERS.items()
])

constructors_df = pd.DataFrame([
    {'constructor_id': k, 'constructor_name': v}
    for k, v in CONSTRUCTORS.items()
])

circuits_df = pd.DataFrame([
    {'circuit_id': k, 'circuit_name': v[0], 'country': v[1], 'length': v[2]}
    for k, v in CIRCUITS.items()
])

# Save to CSV files
races_df.to_csv('f1_races.csv', index=False)
qualifying_df.to_csv('f1_qualifying.csv', index=False)
race_results_df.to_csv('f1_race_results.csv', index=False)
drivers_df.to_csv('f1_drivers.csv', index=False)
constructors_df.to_csv('f1_constructors.csv', index=False)
circuits_df.to_csv('f1_circuits.csv', index=False)
