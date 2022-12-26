#
#  FACT(S):     aix_solarwinds
#
#  PURPOSE:     This custom fact returns a simple boolean to tell whether we're
#		we're running the SolarWinds agent daemon or not.
#
#  RETURNS:     (hash)
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        January 5, 2022
#
#  NOTES:       Myriad names and acronyms are trademarked or copyrighted by IBM
#               including but not limited to IBM, PowerHA, AIX, RSCT (Reliable,
#               Scalable Cluster Technology), and CAA (Cluster-Aware AIX).  All
#               rights to such names and acronyms belong with their owner.
#
#-------------------------------------------------------------------------------
#
#  LAST MOD:    (never)
#
#  MODIFICATION HISTORY:
#
#       (none)
#
#-------------------------------------------------------------------------------
#
Facter.add(:aix_solarwinds) do
    #  This only applies to the AIX operating system
    confine :osfamily => 'AIX'

    #  Define an somewhat empty hash for our output
    l_aixSolarWinds = false

    #  Do the work
    setcode do
        #  Run the command to look through the process list for the SolarWinds agent daemon
        l_lines = Facter::Util::Resolution.exec('/bin/ps -ef 2>/dev/null')

        #  Loop over the lines that were returned
        l_lines && l_lines.split("\n").each do |l_oneLine|
            #  Skip comments and blanks
            l_oneLine = l_oneLine.strip()
            #  Look for a telltale and rip apart that line
            if (l_oneLine =~ / \/opt\/SolarWinds\/Agent\/bin\/swiagent /)
                #  If we found this in "ps" output, then we're definitly running
                l_aixSolarWinds = true
            end
        end

        #  Implicitly return the contents of the variable
        l_aixSolarWinds
    end
end
