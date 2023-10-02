#!/bin/bash

# This is a script to document family dinner preferences

# Silence all output and errors
# Comment out to allow debug ouput
exec 3>&1 4>&2
exec &> /dev/null


# Global variables
recipes_file="Recipes.txt"
scores_file="Scores.txt"
ingredients_file="Ingredients.txt"
template_file="reportTemplate.md"

output_folder="OUTPUT"


# Verify files are available and valid
# Exit on any failed file check
if [[ ! -r $recipes_file ]]; then
    echo "Error: Recipes file does not exist or is not readable." >&4
    exit 404

elif [ ! -r $scores_file ]; then
    echo "Error: Scores file does not exist or is not readable." >&4
    exit 404

elif [ ! -s $scores_file ]; then
    echo "Error: Scores file is empty." >&4
    exit 404

elif [ ! -r $ingredients_file ]; then
    echo "Error: Ingredients file does not exist or is not readable." >&4
    exit 404

elif [ ! -r $template_file ]; then
    echo "Error: Template file does not exist or is not readable." >&4
    exit 404
else
	echo "Input files work" >&3
fi


# Verify output directory exists
# Exit on fail
if [[ ! -d $output_folder && -w $output_folder ]]; then
    echo "Error: Output folder does not exist." >&4
    exit 404
else
	echo "Output folder works" >&3
fi


# Read input files
echo "Reading input files" >&3
# Read RecipeID,Description from Recipes.txt
while IFS=',' read -r recipe_id recipe_description; do
    # Create report filename
    report_filename="$output_folder/report-`echo $recipe_id | cut -c 3-`.md"

    # Replace placeholders with variables
    sed -e "s/\[Recipe Description\]/$recipe_description/g" "reportTemplate.md" > "$report_filename.temp"
    sed -e "s/\[RecipeID\]/$recipe_id/g" "$report_filename.temp" > "$report_filename"

    #mv -f "$report_filename.temp" "$report_filename"


done < "$recipes_file"


# Read RecipeID,ingredient from Ingredients.txt
while IFS=',' read -r recipe_id ingredient; do

    report_filename="$output_folder/report-`echo $recipe_id | cut -c 3-`.md"


	echo -e '\n' "$ingredient" >> "$report_filename"

done < "$ingredients_file"


# Read RecipeID,S1,S2,S3,Comments from Scores.txt
while IFS=',' read -r recipe_id Score1 Score2 Score3 Comments; do

    report_filename="$output_folder/report-`echo $recipe_id | cut -c 3-`.md"

    TotalScore=$(($Score1 + $Score2 + $Score3))

    # Replace placeholders with variables
    sed -e "s/\[Score1\]/$Score1/g" "$report_filename" > "$report_filename.temp"
    sed -e "s/\[Score2\]/$Score2/g" "$report_filename.temp" > "$report_filename"
    sed -e "s/\[Score3\]/$Score3/g" "$report_filename" > "$report_filename.temp"
    sed -e "s/\[Comments\]/$Comments/g" "$report_filename.temp" > "$report_filename"
    sed -e "s/\[TotalScore\]/$TotalScore/g" "$report_filename" > "$report_filename.temp"
    mv -f "$report_filename.temp" "$report_filename"

done < "$scores_file"


# Process each .md file into PDF
echo "Processing PDF files" >&3
cd $output_folder
for file in *.md; do
	filename=`echo $file | cut -c -10 `
	pandoc $file --pdf-engine=pdflatex -o $filename.pdf
done
cd "../"


# Clean	up 
echo "Cleaning up" >&3
rm -f "$output_folder/report-cipeID.md"
rm -f "$output_folder/report-cip.pdf"
rm -f $output_folder/*.temp*
rm -f $output_folder/*.md
