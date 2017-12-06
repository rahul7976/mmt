#!/bin/bash

cd ~/mmt/cmr
java -cp cmr-dev-system-0.1.0-SNAPSHOT-standalone.jar cmr.dev_system.runner |& tee cmr.log &
sleep 30
rake cmr:load

cd ~/mmt
rails s -b 0.0.0.0 |& tee rails.log &

/bin/sh



