#!/bin/bash

quarto render --cache
rsync -r _site/ anders@papagei.bioquant.uni-heidelberg.de:www/dabio25
