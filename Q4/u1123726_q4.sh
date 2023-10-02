#!/bin/bash

# This is a script to document family dinner preferences

# Silence all output and errors
# Comment out to allow debug ouput
#exec &> /dev/null


# Global variables
recipes_file="Recipes.txt"
scores_file="Scores.txt"
ingredients_file="Ingredients.txt"
template_file="reportTemplate.md"

output_folder="OUTPUT/"


# Verify files are available and valid
# Exit on any failed file check
if [[ ! -r $recipes_file ]]; then
    echo "Error: Recipes file does not exist or is not readable."
    exit 404

elif [ ! -r $scores_file ]; then
    echo "Error: Scores file does not exist or is not readable."
    exit 404

elif [ ! -s $scores_file ]; then
    echo "Error: Scores file is empty."
    exit 404

elif [ ! -r $ingredients_file ]; then
    echo "Error: Ingredients file does not exist or is not readable."
    exit 404

elif [ ! -r $template_file ]; then
    echo "Error: Template file does not exist or is not readable."
    exit 404
else
	echo "Input files work"
fi




# Verify output directory exists
# Exit on fail
if [[ ! -d $output_folder && -w $output_folder ]]; then
    echo "Error: Output folder does not exist."
    exit 404
else
	echo "Output folder works"
fi



# Read input files

# Read RecipeID,Description from Recipes.txt


# Read RecipeID,ingredient from Ingredients.txt


# Read RecipeID,S1,S2,S3,Comments from Scores.txt


# Output a .md file for each recipe in recipes.txt
# eof