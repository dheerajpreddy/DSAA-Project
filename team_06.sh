#!/bin/bash

matlab -nosplash -nodesktop -nojvm -r "estimator($1, $2, $3);quit;"
