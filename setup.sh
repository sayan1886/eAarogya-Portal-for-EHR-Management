echo "Setting up the network.."

echo "Creating channel genesis block.."
# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=orderer0MSP" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orderer0.ehr.com/users/Admin@orderer0.ehr.com/msp" \
    -e "CORE_PEER_ADDRESS=peer0.orderer0.ehr.com:7051" cli peer channel create \
    -o orderer.ehr.com:7050 -c ehrchannel -f /etc/hyperledger/configtx/ehrchannel.tx
sleep 5
echo "Channel genesis block created."

echo "peer0.orderer0.ehr.com joining the channel..."
# Join peer0.manf.vlm.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=orderer0MSP" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orderer0.ehr.com/users/Admin@orderer0.ehr.com/msp" \
    -e "CORE_PEER_ADDRESS=peer0.orderer0.ehr.com:7051" cli peer channel join -b ehrchannel.block
sleep 5
echo "peer0.orderer0.ehr.com joined the channel"

echo "peer0.hospital1.ehr.com joining the channel..."
# Join peer0.hospital1.ehr.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=hospital1MSP" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospital1.ehr.com/users/Admin@hospital1.ehr.com/msp" \
    -e "CORE_PEER_ADDRESS=peer0.hospital1.ehr.com:7051" cli peer channel join -b ehrchannel.block
sleep 5
echo "peer0.hospital1.ehr.com joined the channel"

echo "peer0.hospital2.ehr.com joining the channel..."
# Join peer0.hospital2.ehr.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=hospital2MSP" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospital2.ehr.com/users/Admin@hospital2.ehr.com/msp" \
    -e "CORE_PEER_ADDRESS=peer0.hospital2.ehr.com:7051" cli peer channel join -b ehrchannel.block
sleep 5
echo "peer0.hospital2.ehr.com joined the channel"

# echo "peer0.pharmacist.ehr.com joining the channel..."
# # Join peer0.pharmacist.ehr.com to the channel.
# docker exec -e "CORE_PEER_LOCALMSPID=pharmacistMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pharmacist.ehr.com/users/Admin@pharmacist.ehr.com/msp" -e "CORE_PEER_ADDRESS=peer0.pharmacist.ehr.com:7051" cli peer channel join -b ehrchannel.block
# sleep 5
# echo "peer0.pharmacist.ehr.com joined the channel"

# echo "peer0.researcher.ehr.com joining the channel..."
# # Join peer0.researcher.ehr.com to the channel.
# docker exec -e "CORE_PEER_LOCALMSPID=researcherMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researcher.ehr.com/users/Admin@researcher.ehr.com/msp" -e "CORE_PEER_ADDRESS=peer0.researcher.ehr.com:7051" cli peer channel join -b ehrchannel.block
# sleep 5
# echo "peer0.researcher.ehr.com joined the channel"

# echo "peer0.healthCareProvider.ehr.com joining the channel..."
# # Join peer0.insu.vlm.com to the channel.
# docker exec -e "CORE_PEER_LOCALMSPID=healthCareProviderMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/healthCareProvider.ehr.com/users/Admin@healthCareProvider.ehr.com/msp" -e "CORE_PEER_ADDRESS=peer0.healthCareProvider.ehr.com:7051" cli peer channel join -b ehrchannel.block
# sleep 5
# echo "peer0.healthCareProvider.ehr.com joined the channel"

echo "Installing vlm chaincode to peer0.manf.vlm.com..."
# install chaincode
# Install code on orderer0 peer
docker exec -e "CORE_PEER_LOCALMSPID=orderer0MSP" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orderer0.ehr.com/users/Admin@orderer0.ehr.com/msp" \
    -e "CORE_PEER_ADDRESS=peer0.orderer0.ehr.com:7051" cli peer chaincode install \
    -n ehrcc -v 1.0 -p https://github.com/sayan1886/eAarogya-Portal-for-EHR-Management/tree/master/chaincode/ehr/go -l golang
sleep 5
echo "Installed ehr chaincode to peer0.orderer0.ehr.com "


echo "Installing ehr chaincode to peer0.hospital1.ehr.com...."
# Install code on hospital1 peer
docker exec -e "CORE_PEER_LOCALMSPID=hospital1MSP" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospital1.ehr.com/users/Admin@hospital1.ehr.com/msp" \
    -e "CORE_PEER_ADDRESS=peer0.hospital1.ehr.com:7051" cli peer chaincode install \
    -n ehrcc -v 1.0 -p https://github.com/sayan1886/eAarogya-Portal-for-EHR-Management/tree/master/chaincode/ehr/go -l golang
sleep 5
echo "Installed ehr chaincode to peer0.hospital1.ehr.com"

echo "Installing ehr chaincode to peer0.hospital2.ehr.com..."
# Install code on hospital2 peer
docker exec -e "CORE_PEER_LOCALMSPID=hospital2MSP" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hospital2.ehr.com/users/Admin@hospital2.ehr.com/msp" \
    -e "CORE_PEER_ADDRESS=peer0.hospital2.ehr.com:7051" cli peer chaincode install \
    -n ehrcc -v 1.0 -p https://github.com/sayan1886/eAarogya-Portal-for-EHR-Management/tree/master/chaincode/ehr/go -l golang
sleep 5
echo "Installed ehr chaincode to peer0.hospital2.ehr.com"

# echo "Installing ehr chaincode to peer0.pharmacist.ehr.com..."
# # Install code on pharmacist peer
# docker exec -e "CORE_PEER_LOCALMSPID=pharmacistMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pharmacist.ehr.com/users/Admin@pharmacist.ehr.com/msp" -e "CORE_PEER_ADDRESS=peer0.pharmacist.ehr.com:7051" cli peer chaincode install -n ehrcc -v 1.0 -p github.com/ehr/go -l golang
# sleep 5
# echo "Installed ehr chaincode to peer0.pharmacist.ehr.com"

# echo "Installing ehr chaincode to peer0.researcher.ehr.com..."
# # Install code on researcher peer
# docker exec -e "CORE_PEER_LOCALMSPID=researcherMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/researcher.ehr.com/users/Admin@researcher.ehr.com/msp" -e "CORE_PEER_ADDRESS=peer0.researcher.ehr.com:7051" cli peer chaincode install -n ehrcc -v 1.0 -p github.com/ehr/go -l golang
# sleep 5
# echo "Installed ehr chaincode to peer0.researcher.ehr.com"

# echo "Installing ehr chaincode to peer0.healthCareProvider.ehr.com..."
# # Install code on healthCareProvider peer
# docker exec -e "CORE_PEER_LOCALMSPID=healthCareProviderMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/healthCareProvider.ehr.com/users/Admin@healthCareProvider.ehr.com/msp" -e "CORE_PEER_ADDRESS=peer0.healthCareProvider.ehr.com:7051" cli peer chaincode install -n ehrcc -v 1.0 -p github.com/ehr/go -l golang
# sleep 5
# echo "Installed ehr chaincode to peer0.healthCareProvider.ehr.com"


echo "Instantiating ehr chaincode.."
docker exec -e "CORE_PEER_LOCALMSPID=orderer0MSP" \
    -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/orderer0.ehr.com/users/Admin@orderer0.ehr.com/msp" \
    -e "CORE_PEER_ADDRESS=peer0.orderer0.ehr.com:7051" cli peer chaincode instantiate \
    -o orderer0.ehr.com:7050 -C ehrchannel -n ehrcc -l golang -v 1.0 -c '{"Args":[""]}' \
    -P "OR ('orderer0MSP.member','hospital1MSP.member','hospital2MSP.member','pharmacistMSP.member','researcherMSP.member', 'healthCareProviderMSP.member')"
echo "Instantiated ehr chaincode."
echo "Following is the docker network....."

docker ps

