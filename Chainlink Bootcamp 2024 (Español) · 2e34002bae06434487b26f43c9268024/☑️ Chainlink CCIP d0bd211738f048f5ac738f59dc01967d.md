# ☑️ Chainlink CCIP

## Recursos

**Documetación oficial:** 

- [https://docs.chain.link/ccip](https://docs.chain.link/ccip)
- [https://chain.link/cross-chain](https://chain.link/cross-chain)

**Servicio:** 

[https://ccip.chain.link/](https://ccip.chain.link/)

**Recursos adicionales**

- [https://andrej-rakic.gitbook.io/chainlink-ccip/getting-started/chainlink-ccip](https://andrej-rakic.gitbook.io/chainlink-ccip/getting-started/chainlink-ccip)

## Learning

- Interoperabilidad
    - Habilidad de intercambiar información entre distintos sistemas o redes (incluso sin son incompatibles)
    - Las BC no pueden comunicarse con otras BC de manera nativa. Son redes aisladas.
    - Bridge
        - Son centralizados y hay que depositar la confianza, y fondos, en ellos.
- Cross Chain Interoperability Protocol
    - conecta redes BC a través de *lanes*
        - combinación unica de la ruta de una BC origen a BC destino.
        - son unidireccionales
- Funcionalidades
    - Transferir tokens (entre un cojunto de tokens soportados)
        - Mecanismos
            - Lock&Mint
                - puntear tokens nativos a cadenas en las que no son nativos acuñando una versión synthetic/wrapped
            - Burn&Mint
                - para tokens emitidos en múltiples cadenas
    - Enviar cualquier tipo de datos
    - Enviar Tokens + Mensajes (datos)
- Técnico
    - CCIP **Sender**
        - Puede ser una EOA o un SC
    - CCIP **Receiver**
        - Puede ser una EOA o un SC que implemente CCIPReciver.sol
    - CCIP **Router**
        - Es el SC responsable de iniciar las interacciones “cross-chain”
        - Existe un Router por cadena
        - Los Senders tienen que aprobar el Router para que sea capaz de gastar/transferir los tokens del caller.
        - El Router es el contrato encargado de entregar los tokens/mensajes a la cuenta/SC destino (receiver)
        - 
- Facturación
    - Fees = Gas Cost + Premium
        - los Fees pueden pagarse con LINK o gas nativo
    - El Fee se cobra 1vez y el Origen
        - incluye el pago del gas necesario en el Destino
- Complementary concepts (Security)
    - **Decentralized Oracle Network** (DON)
        - provides foundational security
        - 2 responsibilities
            - **committing DON**
                - commits to CCIP messages on the source chain that are finalized by creating a Merkle tree of these messages and publishing its Merkle root on the destination chain
            - **executing DON**
                - submits messages to the destination chain for execution, along with cryptographic proof that the messages are included in the blessed Merkle root
                - CCIP verifies these proofs against the blessed Merkle root, and if successful, the messages are executed on the destination chain.
    - **Risk Management Network**
        - built as an independent implementation, on a different stack, in a different programming language
        - verifies the Committing DON by performing the same task
    - [Five level of Security](https://blog.chain.link/five-levels-cross-chain-security/)
        - L1 Centralized
        - L2 Decentralization Theather
        - L3 One Network
        - L4 Multiple Networks
        - L5 CommitingDON + RISK Mgt Network + ExecutingDON
- Arquitectura

![Untitled](%E2%98%91%EF%B8%8F%20Chainlink%20CCIP%20d0bd211738f048f5ac738f59dc01967d/Untitled.png)

![Untitled](%E2%98%91%EF%B8%8F%20Chainlink%20CCIP%20d0bd211738f048f5ac738f59dc01967d/Untitled%201.png)

## Bootcamp (day4)

### Recursos:

- [Material presentación](https://docs.google.com/presentation/d/e/2PACX-1vSWSZfMuNAjQrRFEsUXZad1j-1POA_XlGpsXfy0uQmwAhFjBxyysJ8Y8xKL18FGu77NXFfovotT90F2/pub?start=false&loop=false&delayms=3000&slide=id.g2acdc1ce0f8_0_0)
- [Clase grabada Youtube](https://www.youtube.com/watch?v=6KtafiSU65g)

### Challenge

Hacer una transferencia de tokens entre la red Fuji y Sepolia.

### Contratos desarrollados:

- [CCIPTokenSenderFujiSepolia.sol](../contracts/CCIPTokenSenderFujiSepolia.sol)
    - 0x7F56967d6e46601A9c98D17F845E1fC2F2D63976
    - [https://testnet.snowtrace.io/tx/0xbb53cffbf4f95730004abd332866e7b69746e7e4d0d2d0d8d46bc1169cd456d0](https://testnet.snowtrace.io/tx/0xbb53cffbf4f95730004abd332866e7b69746e7e4d0d2d0d8d46bc1169cd456d0)

### Técnico

It is necessary to set up some “configurations” related to SmartContracts that should be used (provided by Chainlink). You will need:

- Router address for the Origin Network
- LINK Token Smart Contract (for the Origin Network)
- ChainSelector Id (identify the destination chain)
- bnmToken is one of the Supported tokens that you can use

```solidity
// https://docs.chain.link/resources/link-token-contracts#fuji-testnet
    address link= 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846;

    // https://docs.chain.link/ccip/supported-networks/v1_2_0/testnet#avalanche-fuji
    address routerAddress = 0xF694E193200268f9a4868e4Aa017A0118C9a8177;
    address bnmToken = 0xD21341536c5cF5EB1bcb58f6723cE26e8D8E90e4;
    
    // https://docs.chain.link/ccip/supported-networks/v1_2_0/testnet#ethereum-sepolia
    uint64 destinationChainSelector = 16015286601757825753;
```

```solidity
function transferToSepolia(
        address _receiver,
        uint256 _amount
    )
        external
        returns (bytes32 messageId)
    {
        Client.EVMTokenAmount[]
            memory tokenAmounts = new Client.EVMTokenAmount[](1);
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({
            token: bnmToken,
            amount: _amount
        });
        tokenAmounts[0] = tokenAmount;
       
        // Build the CCIP Message
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(_receiver),
            data: "",
            tokenAmounts: tokenAmounts,
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 0})
            ),
            feeToken: address(linkToken)
        });
       
        // CCIP Fees Management
        uint256 fees = router.getFee(destinationChainSelector, message);

        if (fees > linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), fees);

        linkToken.approve(address(router), fees);
       
        // Approve Router to spend CCIP-BnM tokens we send
        IERC20(bnmToken).approve(address(router), _amount);
       
        // Send CCIP Message
        messageId = router.ccipSend(destinationChainSelector, message);
       
        emit TokensTransferred(
            messageId,
            destinationChainSelector,
            _receiver,
            bnmToken,
            _amount,
            link,
            fees
        );  
    }
```

## Bootcamp (day7)

### Recursos:

- [Material presentación](https://docs.google.com/presentation/d/e/2PACX-1vSWSZfMuNAjQrRFEsUXZad1j-1POA_XlGpsXfy0uQmwAhFjBxyysJ8Y8xKL18FGu77NXFfovotT90F2/pub?start=false&loop=false&delayms=3000&slide=id.g2acdc1ce0f8_0_0)
- [Clase grabada Youtube](https://www.youtube.com/watch?v=y_iOxra1oLc)

### Challenge

Creamos un NFT (ERC-721) dinámico que hace uso de [Data Feeds](%E2%98%91%EF%B8%8F%20Chainlink%20Data%20feeds%20a8fa1dd1119e48e9a77dd15e7d293663.md) para obtener la cotización del par BTC/USD y según si el valor ha subido/bajado actualiza la metadata del NFT en el propio SmartContract (no hace uso de un data storage externo).

Usamos CCIP para hacer un mintado “cross-chain”: desde Fuji a Sepolia (lanzamos “la orden” desde un SC desplegado en Fuji y se mintea en Sepolia). El SC 721 está desplegado en Sepolia.

[Opensea collection](https://testnets.opensea.io/es/collection/crosschain-price-341) 

![Untitled](%E2%98%91%EF%B8%8F%20Chainlink%20CCIP%20d0bd211738f048f5ac738f59dc01967d/Untitled%202.png)

### Contratos desarrollados:

- CrossChainPriceNFT.sol
    - [https://sepolia.etherscan.io/address/0x62d09d075c31e6eeddd9ab3e5e74834e5aef8ed9](https://sepolia.etherscan.io/address/0x62d09d075c31e6eeddd9ab3e5e74834e5aef8ed9)
- CrossDestinationMinter.sol
    - [https://sepolia.etherscan.io/address/0xcdcb47546561f3bea7cd6913a9d628dad5177c8e](https://sepolia.etherscan.io/address/0xcdcb47546561f3bea7cd6913a9d628dad5177c8e)
- CrossSourceMinter.sol
    - [https://testnet.snowtrace.io/address/0xcdc32dc6b7c4022ac2bbbf2cad500e6d0469ef77](https://testnet.snowtrace.io/address/0xcdc32dc6b7c4022ac2bbbf2cad500e6d0469ef77)
- Evidencias
    - [https://ccip.chain.link/msg/0x304ab1910bb3d5480a8f0b2df0036d0b0fe43790e5fc6c36a4b550ff108e0480](https://ccip.chain.link/msg/0x304ab1910bb3d5480a8f0b2df0036d0b0fe43790e5fc6c36a4b550ff108e0480)
    - [https://testnets.opensea.io/es/collection/crosschain-price-341](https://testnets.opensea.io/es/collection/crosschain-price-341)

### Técnico

```solidity
// Update MetaData
    function updateMetaData(uint256 tokenId, uint256 sourceId) public {
        // Create the SVG string
        string memory finalSVG = buildSVG(sourceId);

        // Base64 encode the SVG
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Cross-chain Price SVG",',
                        '"description": "SVG NFTs in different chains",',
                        '"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSVG)),
                        '",',
                        '"attributes": [',
                        '{"trait_type": "source",',
                        '"value": "',
                        chain[sourceId].name,
                        '"},',
                        '{"trait_type": "price",',
                        '"value": "',
                        lastPrice.toString(),
                        '"}',
                        "]}"
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        // Set token URI
        _setTokenURI(tokenId, finalTokenURI);
    }

    // Build the SVG string
    function buildSVG(uint256 sourceId) internal returns (string memory) {
        // Create SVG rectangle with random color
        string memory headSVG = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' version='1.1' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:svgjs='http://svgjs.com/svgjs' width='500' height='500' preserveAspectRatio='none' viewBox='0 0 500 500'> <rect width='100%' height='100%' fill='",
                chain[sourceId].color,
                "' />"
            )
        );
        // Update emoji based on price
        string memory bodySVG = string(
            abi.encodePacked(
                "<text x='50%' y='50%' font-size='128' dominant-baseline='middle' text-anchor='middle'>",
                comparePrice(),
                "</text>"
            )
        );
        // Close SVG
        string memory tailSVG = "</svg>";

        // Concatenate SVG strings
        string memory _finalSVG = string(
            abi.encodePacked(headSVG, bodySVG, tailSVG)
        );
        return _finalSVG;
    }
```

### Futuros retos

- [ ]  

[backup page](%E2%98%91%EF%B8%8F%20Chainlink%20CCIP%20d0bd211738f048f5ac738f59dc01967d/backup%20page%20f7d0c8c737e94b0983362c4073e39b41.md)