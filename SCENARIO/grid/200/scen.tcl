# ======================================================================
# Define options
# ======================================================================

set val(chan)               Channel/WirelessChannel        ;# channel type
set val(prop)               Propagation/TwoRayGround    ;# radio-propagation model
set val(netif)              Phy/WirelessPhy            ;# network interface type
set val(mac)                Mac/802_11            ;# MAC type
set val(ifq)                Queue/DropTail/PriQueue        ;# interface queue type
set val(ll)                 LL                ;# link layer type
set val(ant)                Antenna/OmniAntenna        ;# antenna model
set opt(x)              700                   ;# X dimension of the topography
set opt(y)              700                   ;# Y dimension of the topography
set val(ifqlen)         1000                ;# max packet in ifq
set val(nn)             200        ;# how many nodes are simulated
set val(seed)                  1.0                ;
set val(adhocRouting)   AODV                ;# routing protocol
set val(stop)           200                ;# simulation time
set val(cp)                    "cbr.txt"            ;#<-- traffic file
set val(sc)                    "scenario.txt"            ;#<-- mobility file 

set val(energy_mod)         EnergyModel                 ;# energy model
set val(energy_init)        100                           ;# init val for energy
set val(tx_power)           1.65                        ;# energy consume for transmiting packet
set val(rx_power)           1.4                         ;# energy consume for receiving packet
set val(idle_power)         0.5                        ;# energy consume for idle
set val(sleep_power)        0.3                        ;# energy consume for sleep mode


# =====================================================================
# Main Program
# ======================================================================
# Initialize Global Variables
# create simulator instance

set ns_        [new Simulator]

# setup topography object

set topo    [new Topography]


set tracefd    [open scenario.tr w]
set namtrace    [open scenario.nam w]

$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)

# set up topology object
set topo                [new Topography]
$topo load_flatgrid $opt(x) $opt(y)

# Create God
set god_ [create-god $val(nn)]


$ns_ node-config    -adhocRouting $val(adhocRouting) \
                    -llType $val(ll) \
                    -macType $val(mac) \
                    -ifqType $val(ifq) \
                    -ifqLen $val(ifqlen) \
                    -antType $val(ant) \
                    -propType $val(prop) \
                    -phyType $val(netif) \
                    -channelType $val(chan) \
                    -energyModel $val(energy_mod) \
                    -initialEnergy $val(energy_init) \
                    -txPower $val(tx_power) \
                    -rxPower $val(rx_power) \
                    -idlePower $val(idle_power) \
                    -sleepPower $val(sleep_power) \
                    -topoInstance $topo \
                    -agentTrace ON \
                    -routerTrace ON \
                    -macTrace ON \
                    -movementTrace ON

                                 
###

# 802.11p default parameters
Phy/WirelessPhy    set    RXThresh_ 5.57189e-11 ; #250m
Phy/WirelessPhy set    CSThresh_ 5.57189e-11 ; #250m

###
#  Create the specified number of nodes [$val(nn)] and "attach" them
#  to the channel. 
for {set i 0} {$i < $val(nn)} {incr i} {
        set node_($i) [$ns_ node]
        $node_($i) random-motion 0 ;# disable random motion
}

# Define node movement model
puts "Loading connection pattern..."
source $val(cp)

# Define traffic model
puts "Loading scenario file..."
source $val(sc)

# Define node initial position in nam

for {set i 0} {$i < $val(nn)} {incr i} {

    # 20 defines the node size in nam, must adjust it according to your scenario
    # The function must be called after mobility model is defined
    
    $ns_ initial_node_pos $node_($i) 20
}

# Tell nodes when the simulation ends
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop).0 "$node_($i) reset";
}

#$ns_ at  $val(stop)    "stop"
$ns_ at  $val(stop).0002 "puts \"NS EXITING...\" ; $ns_ halt"

puts $tracefd "M 0.0 nn $val(nn) x $opt(x) y $opt(y) rp $val(adhocRouting)"
puts $tracefd "M 0.0 sc $val(sc) cp $val(cp) seed $val(seed)"
puts $tracefd "M 0.0 prop $val(prop) ant $val(ant)"

puts "Starting Simulation..."
$ns_ run

