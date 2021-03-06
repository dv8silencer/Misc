#!/bin/bash
echo "***ALPHA SOFTWARE.  USE AT YOUR OWN RISK.  NO GUARANTEES ARE GIVEN***"
echo "Users must provide ALL 6 command line arguments:
	-c NameOfBeaconChainUsernameToCreate	   /// Please provide a name to be used for the beacon chain user on this system. This will be created and should not already exist!
	-d NameOfValidatorUsernameToCreate	   /// Please provide a name to be used for the validator user on this system. This will be created and should not already exist!
	-b /path/to/prysm/beacon-chain/executable  /// Of note this should NOT provide any further beacon-chain arguments!  Only the path to the binary/script.
	-v /path/to/prysm/validator/executable	   /// Of note this should NOT provide any further validator arguments!  Only the path to the binary/script.
	-g /path/to/prysm/beacon-chain/config.yaml /// THIS is where arguments to be passed to the beacon-chain are stored. Ownership will change to new beacon user.
	-i /path/to/prysm/validator/config.yaml	   /// THIS is where arguments to be passed to the validator are stored. Ownership will change to new validator user.
	"
echo "
Do not run the script with sudo.  You'll be asked for your password inside the script.  You must be logged in to a user that has a working validator.  For example, keys must have already been imported.  ~/.eth2validators must be in good condition."

ID=$(id -u)

if (( ID == 0 ))
then
	echo "Do not start the script as/with root/sudo"
	exit 1
fi

beaconName=""
validatorName=""
beaconXPath=""
validatorXPath=""
beaconConfig=""
validatorConfig=""

while getopts "b:v:g:i:c:d:" opt; do
  case $opt in
    c)
      beaconName=$OPTARG
      ;;
    d)
      validatorName=$OPTARG
      ;;
    b)
      beaconXPath=$OPTARG
      ;;
    v)
      validatorXPath=$OPTARG
      ;;
    g)
      beaconConfig=$OPTARG
      ;;
    i)
      validatorConfig=$OPTARG
      ;;
  esac
done

if [[ "$beaconName" == "" ]] || [[ "$validatorName" == "" ]] || [[ "$beaconXPath" == "" ]] || [[ "$validatorXPath" == "" ]] || [[ "$beaconConfig" == "" ]] || [[ "$validatorConfig" == "" ]] 
then
	echo "Missing parameters!"
	exit 1
fi

if [ ! -f "$beaconXPath" ]
then
	echo "$beaconXPath does not exist!"
	exit 1
fi

if [ ! -f "$validatorXPath" ]
then
	echo "$validatorXPath does not exist!"
	exit 1
fi

if [ ! -f "$beaconConfig" ]
then
	echo "$beaconConfig does not exist!"
	exit 1
fi

if [ ! -f "$validatorConfig" ]
then
	echo "$validatorConfig does not exist!"
	exit 1
fi

echo "------------------------------------"
echo "------------------------------------"
echo "This software should have come with the GPLv3 license statement.  The following is it in part:"
echo "15. Disclaimer of Warranty.
THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

16. Limitation of Liability.
IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES."
echo "------------------------------------"
echo "------------------------------------"

echo "
"
read -p "Press enter if you agree and want to proceed.  Exit the program otherwise.  See the initial output of this script for further details on usage"

read -p "You will be prompted to set up $beaconName's password and other details. Press enter to continue."
sudo adduser "$beaconName"
read -p "You will be prompted to set up $validatorName's password and other details. Press enter to continue."
sudo adduser "$validatorName"

sudo chown $beaconName:$beaconName $beaconConfig
sudo chown $validatorName:$validatorName $validatorConfig

echo "[Unit]
Description=beacon-chain
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=$beaconName
Group=$beaconName
Restart=always
RestartSec=5
ExecStart=$beaconXPath --config-file $beaconConfig

[Install]
WantedBy=multi-user.target" > ~/beacon.service
sudo mv ~/beacon.service /etc/systemd/system/

echo "[Unit]
Description=validator
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=$validatorName
Group=$validatorName
Restart=always
RestartSec=5
ExecStart=$validatorXPath --config-file $validatorConfig

[Install]
WantedBy=multi-user.target" > ~/validator.service
sudo mv ~/validator.service /etc/systemd/system/

sudo systemctl enable beacon
sudo systemctl enable validator
sudo systemctl start beacon
sudo systemctl start validator


