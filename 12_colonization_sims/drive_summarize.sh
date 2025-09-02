#!/bin/bash

sed -i 's/-1/99999/g' output_loui/*
python summarize_loui.py -i output_loui -o output_loui/summarized
