rm -R crypto-config/

cryptogen generate --config=crypto-config.yaml

rm -R config/

configtxgen -profile ehrOrgOrdererGenesis -outputBlock ./config/genesis.block -channelID ehrchannel

configtxgen -profile ehrOrgChannel -outputCreateChannelTx ./config/ehrchannel.tx -channelID ehrchannel
