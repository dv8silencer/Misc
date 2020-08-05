#NEED TO ECHO STUFF INCLUDING USAGE
echo "***ALPHA SOFTWARE.  USE AT YOUR OWN RISK.  NO GUARANTEES ARE GIVEN***"
echo "Users must provide all 4 command line arguments:
	-c NameOfBeacon-ChainUsernameToCreate	   /// Please provide a name to be used for the beacon chain user on this system. This will be created and should not already exist!
	-d NameOfValidatorUsernameToCreate	   /// Please provide a name to be used for the validator user on this system. This will be created and should not already exist!
	-b /path/to/prysm/beacon-chain/executable  /// Of note this should NOT provide any further beacon-chain arguments!
	-v /path/to/prysm/validator/executable	   /// Of note this should NOT provide any further validator arguments!
	-g /path/to/prysm/beacon-chain/config.yaml /// THIS is where arguments to be passed to the beacon-chain are stored.
	-i /path/to/prysm/validator/config.yaml	   /// THIS is where arguments to be passed to the validator are stored.
	"

beaconName=""
validatorName=""
beaconXPath=""
validatorXPath=""
beaconConfig=""
validatorConfig=""


while getopts "b:v:g:i:c:d:" opt; do
  case $opt in
    c)
      beaconName = $OPTARG
      ;;
    d)
      validatorName = $OPTARG
      ;;
    b)
      beaconXPath = $OPTARG
      ;;
    v)
      validatorXPath = $OPTARG
      ;;
    g)
      beaconConfig = $OPTARG
      ;;
    i)
      validatorConfig = $OPTARG
      ;;
  esac
done

if [[ "$beaconName" == "" ]] || [[ "$validatorName" == "" ]] || [[ "$beaconXPath" == "" ]] || [[ "$validatorXPath" == "" ]] || [[ "$beaconConfig" == "" ]] || [[ "$validatorConfig" == "" ]] 
then
	echo "Missing parameters."
	exit 1
fi

#DEBUG - TO BE DELETED
echo "$beaconName"
echo "$validatorName"
echo "$beaconXPath"
echo "$validatorXPath"
echo "$beaconConfig"
echo "$validatorConfig"

# CREATE WARNING HERE AND GIVE OPPORTUNITY TO EXIT
echo "------------------------------------"
echo "------------------------------------"
echo "15. Disclaimer of Warranty.
THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

16. Limitation of Liability.
IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES."
echo "------------------------------------"
echo "------------------------------------"

echo "
Enter any key if you agree and want to proceed.  Exit the program otherwise.  See the initial output of this script for further details on usage"

#DO STUFF




