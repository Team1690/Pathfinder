Graphs=""

Graphs="${Graphs} Path"
Graphs="${Graphs} Path-Derivative"
Graphs="${Graphs} Position"

Graphs="${Graphs} PositionX-Time"
Graphs="${Graphs} PositionY-Time"

Graphs="${Graphs} Heading-Distance"
Graphs="${Graphs} Heading-Time"

Graphs="${Graphs} Omega-Distance"
Graphs="${Graphs} Omega-Time"

Graphs="${Graphs} Acceleration-Time"

Graphs="${Graphs} Velocity-Time"
Graphs="${Graphs} Velocity-Distance"

Graphs="${Graphs} VelocityX-Time"
Graphs="${Graphs} VelocityY-Time"



for Graph in ${Graphs}; do
    if [[ $OSTYPE == 'darwin'* ]];
    then
        open -a "Google Chrome" http://localhost:8081/${Graph};
    else
        start chrome http://localhost:8081/${Graph};
    fi
done
