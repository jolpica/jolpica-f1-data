# jolpica-f1-data
Data imports and corrections for the jolpica-f1 api.

# Contributing

## Data Folder Structure
All data to be uploaded to jolpica-f1 lives inside the `data/` folder. This is the <ins>**root**</ins> folder

Inside this folder are multiple sub-folders to group data by year for example `2025/` (if data does not belong to a year, feel free to use the `0000/` folder). This is the <ins>**season**</ins> folder.

Any file inside a season folder is an <ins>**import**</ins> folder. This is where all json data to upload should live. 

Inside an import folder, **all json files are combined** together into a single upload to the API, this is to help ensure creations & updates happen in the correct order. As a result, you can split data into as many files or folders as you'd like inside an import folder and it will have no affect on the upload.

## Data File Structure
Data follows the jolpica-f1 database schema, you can find an interactive view of all tables [here](https://dbdocs.io/jolpica/jolpica-f1?view=relationships). However knowledge of this is not required.

Every `.json` file should contain a list at its root, containing any number of import objects in any order.

Data import objects are defined in the `data_import` package of the `jolpica-schemas`, you can find the information the defined pydantic schemas [here](https://github.com/jolpica/jolpica-f1/blob/main/libraries/jolpica-schemas/src/jolpica_schemas/data_import.py). If you are generating your data using python, it's highly reccommended (but not required) to install the package ([example of how to install](https://github.com/harningle/fia-doc/blob/458b4a5ebb7396cef4ccd36d60cc0f1b4bf64a65/pyproject.toml#L25)), and use the pydantic models to validate and then export your data to json.

All data added to this repository is "patched" to existing data, so for example if you add data to update just the time of a race result, all of data will stay the same.

It's easiest to walk through an example import, the following will update the SessionEntry (aka result data):
```jsonc
[
  {
    "foreign_keys": { // Which driver, in which session do we want to add data
      "year": 2025,
      "round": 24,
      "session": "R", // "R" for Race, R,Q1,Q2,Q3,SR,SQ1,SQ2,SQ3,FP1,FP2,FP3 are valid.
      "car_number": 1 // Car number 1 - Max Verstappen in this case
    },
    "object_type": "SessionEntry", // What type of object are we defining (refer to jolpica-schemas)
    "objects": [
      {
        "laps_completed": 58,
        "time": { // As a timedelta has no native json object, we use a custom object
          "_type": "timedelta",
          "milliseconds": 5167469
        }
      }
    ]
  }
]
```
*Comments are not permitted in json file, but added here for demonstration*

In this example we are updating the race result of Max Verstappen in the 2025 Abu Dhabi Grand Prix Race to say he completed 58 laps, and he finished the race in 5167.469 seconds. This will keep his "position", "points", and other omitted fields data the same.

### Historical Qualifying Data
If you want to add data for qualifying session before the use of Q1,Q2,Q3 qualifying, beware that the API uses abstract session types to track these. We use "QB" for sessions where the fastest lap across all QB sessions is used to determine qualifying (there may be 1 or 2 QB sessions). "QO" is used for qualifying sessions which do not affect the grid, but determine the qualifying order for the following qualifying session, "QA" is used for the first half of the 2005 season, where both sessions were addedd together for a final time.

## Getting Help
Thanks for considering contributing data to the jolpica-f1 project, if you need help at all please either [join our discord](https://discord.gg/kq7yDddASn), or start a discussion thread.



