#!/bin/bash

#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 23 Aug 2022
# Just a script to run snapp_input_maker.sh for each replicate.
# Arguments in order are vcf input name, outstem, and sample number

sh snapp_input_maker.sh snapp95_even.vcf snapp95_even 14
sh snapp_input_maker.sh snapp95_group.vcf snapp95_group 17
sh snapp_input_maker.sh snapp95_island.vcf snapp95_island 30
